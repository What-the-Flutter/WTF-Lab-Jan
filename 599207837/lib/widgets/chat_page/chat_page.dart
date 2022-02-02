import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/firebase/storage_provider.dart';

import '../../entity/entities.dart';
import '../theme_provider/theme_cubit.dart';
import '../theme_provider/theme_state.dart';
import '../widgets.dart';
import 'chat_page_cubit.dart';
import 'chat_page_state.dart';

class ChatPage extends StatelessWidget {
  final Topic topic;

  ChatPage({required this.topic});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatPageCubit()..getElements(topic),
      child: _ChatPage(
        topic: topic,
      ),
    );
  }
}

class _ChatPage extends StatelessWidget {
  final Topic topic;

  _ChatPage({required this.topic});

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeCubit>().state;
    return BlocBuilder<ChatPageCubit, ChatPageState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.colors.backgroundColor,
          appBar: _chatAppBar(theme, context),
          body: Container(
            decoration: theme.backgroundPath == null
                ? null
                : BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(theme.backgroundPath!),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
            child: BackdropFilter(
              filter: theme.backgroundPath == null
                  ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                  : ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: theme.backgroundPath == null ? null : Colors.black.withOpacity(0.5),
                child: Column(
                  children: <Widget>[
                    if (state.selectionFlag)
                      Container(
                        decoration: BoxDecoration(color: theme.colors.backgroundColor),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  context.read<ChatPageCubit>().deleteSelected();
                                  context.read<ChatPageCubit>().setSelection(false);
                                },
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                child: const Text('Move to'),
                                onPressed: () {
                                  Alerts.moveAlert(
                                    context: context,
                                    currentTopic: topic,
                                    onMoved: (topic) {
                                      Navigator.pop(context);
                                      context.read<ChatPageCubit>().moveSelected(topic);
                                      context.read<ChatPageCubit>().setSelection(false);
                                    },
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  context.read<ChatPageCubit>().clearSelection();
                                  context.read<ChatPageCubit>().setSelection(false);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: state.messages.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatMessage(
                            key: Key(state.messages[index].uuid.toString()),
                            item: state.messages[index],
                            onDeleted: () => context.read<ChatPageCubit>().deleteMessage(index),
                            onEdited: () => context
                                .read<ChatPageCubit>()
                                .startEditing(index, state.messages[index]),
                            onSelection: () => context.read<ChatPageCubit>().setSelection(true),
                            onSelected: () =>
                                context.read<ChatPageCubit>().onSelect(state.messages[index]),
                            selection: state.selectionFlag,
                          );
                        },
                      ),
                    ),
                    _attachments(state, context),
                    _inputForm(state, context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _chatAppBar(ThemeState theme, BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: theme.colors.themeColor2,
      flexibleSpace: SafeArea(
        child: BlocBuilder<ChatPageCubit, ChatPageState>(
          builder: (context, state) {
            return state.searchPage
                ? _searchBarRow(context, theme, state)
                : _defaultAppBarRow(context, theme);
          },
        ),
      ),
    );
  }

  Widget _searchBarRow(BuildContext context, ThemeState theme, ChatPageState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(color: theme.colors.textColor1),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 5, left: 10),
                hintText: 'Search...',
                hintStyle: TextStyle(color: theme.colors.minorTextColor),
                filled: true,
                fillColor: theme.colors.themeColor2,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: theme.colors.minorTextColor,
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: theme.colors.underlineColor,
                    width: 0.5,
                  ),
                ),
              ),
              controller: state.searchController,
            ),
          ),
        ),
        IconButton(
          onPressed: () => context.read<ChatPageCubit>().finishSearch(),
          icon: Icon(
            Icons.close_rounded,
            color: theme.colors.iconColor2,
          ),
        ),
      ],
    );
  }

  Widget _defaultAppBarRow(BuildContext context, ThemeState theme) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: theme.colors.iconColor2,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        CircleAvatar(
          backgroundColor: theme.colors.avatarColor,
          child: Icon(
            topic.icon,
            color: Colors.white,
            size: 25,
          ),
          radius: 20,
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                topic.name,
                style: TextStyle(
                  fontSize: theme.fontSize.primary,
                  fontWeight: FontWeight.w600,
                  color: theme.colors.textColor2,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                'Online',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: theme.fontSize.secondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded),
          color: theme.colors.iconColor2,
          tooltip: 'Search messages',
          onPressed: () => context.read<ChatPageCubit>().startSearch(),
        ),
      ],
    );
  }

  Widget _attachments(ChatPageState state, BuildContext context) {
    final theme = context.read<ThemeCubit>().state;
    return state.imagePath == null && state.imageName == null
        ? Container()
        : Container(
            constraints: const BoxConstraints(maxHeight: 80),
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: theme.colors.themeColor2,
              border: Border(
                bottom: BorderSide(width: 1.5, color: Colors.grey.shade600),
              ),
            ),
            child: Row(
              children: [
                _attachedImage(
                    state.imagePath ?? state.imageName!, context, state.imagePath == null),
              ],
            ));
  }

  Widget _attachedImage(String imageInfo, BuildContext context, bool url) {
    final theme = context.read<ThemeCubit>().state;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: url
                ? FutureBuilder(
                    future: StorageProvider.getImageUrl(imageInfo),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.network(
                          snapshot.data as String,
                          fit: BoxFit.contain,
                        );
                      } else {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.white,
                        ));
                      }
                    },
                  )
                : Image.file(
                    File(imageInfo),
                    fit: BoxFit.contain,
                  ),
          ),
        ),
        GestureDetector(
          onTap: () => context.read<ChatPageCubit>().removeAttachedImage(),
          child: Icon(
            Icons.highlight_remove_outlined,
            color: theme.colors.iconColor1,
          ),
        ),
      ],
    );
  }

  Widget _inputForm(ChatPageState state, BuildContext context) {
    switch (state.addedType) {
      case (0):
        return _defaultInputForm(true, state, context);
      case (1):
        return _eventInputForm(state, context);
      default:
        return _defaultInputForm(false, state, context);
    }
  }

  Widget _eventInputForm(ChatPageState state, BuildContext context) {
    final theme = context.read<ThemeCubit>().state;
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
      width: double.infinity,
      color: theme.colors.themeColor2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 40,
            child: FloatingActionButton(
              heroTag: 'changeAddedType',
              backgroundColor: theme.colors.buttonColor,
              onPressed: () => context.read<ChatPageCubit>().changeAddedType(),
              child: Container(
                height: 30,
                width: 30,
                child: Icon(
                  state.addedIcon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Form(
              child: Column(
                children: [
                  BlocBuilder<ChatPageCubit, ChatPageState>(
                    builder: (context, state) {
                      return DateTimePicker(
                        selectTime: (value) => context.read<ChatPageCubit>().setSelectedTime(value),
                        selectDate: (value) => context.read<ChatPageCubit>().setSelectedDate(value),
                        selectedDate: state.selectedDate,
                        labelText: 'Scheduled date',
                        selectedTime: state.selectedTime,
                      );
                    },
                  ),
                  Container(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Write event description...',
                        hintStyle: TextStyle(
                          color: theme.colors.minorTextColor,
                          fontSize: theme.fontSize.primary,
                        ),
                        border: InputBorder.none,
                      ),
                      controller: state.descriptionController,
                      style: TextStyle(
                        color: theme.colors.textColor2,
                        fontSize: theme.fontSize.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => context.read<ChatPageCubit>().loadImageFromGallery(),
                child: Icon(
                  Icons.photo_camera,
                  color: Colors.grey.shade600,
                  size: 28,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 40,
                child: FloatingActionButton(
                  heroTag: 'sendMessage',
                  backgroundColor: theme.colors.buttonColor,
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (!state.editingFlag && state.descriptionController!.text.isNotEmpty) {
                      context.read<ChatPageCubit>().addEvent(topic);
                    } else if (state.descriptionController!.text.isNotEmpty) {
                      context.read<ChatPageCubit>().finishEditing(true);
                    }
                  },
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _defaultInputForm(bool isTask, ChatPageState state, BuildContext context) {
    final theme = context.read<ThemeCubit>().state;
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
      height: 60,
      width: double.infinity,
      color: theme.colors.themeColor2,
      child: Row(
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'changeAddedType',
            backgroundColor: theme.colors.buttonColor,
            onPressed: () => context.read<ChatPageCubit>().changeAddedType(),
            child: Container(
              height: 30,
              width: 30,
              child: Icon(
                state.addedIcon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: isTask ? 'Write task...' : 'Write note...',
                hintStyle: TextStyle(
                  color: theme.colors.minorTextColor,
                  fontSize: theme.fontSize.primary,
                ),
                border: InputBorder.none,
              ),
              controller: state.descriptionController,
              style: TextStyle(
                color: theme.colors.textColor2,
                fontSize: theme.fontSize.primary,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () => context.read<ChatPageCubit>().loadImageFromGallery(),
            child: Icon(
              Icons.photo_camera,
              color: Colors.grey.shade600,
              size: 28,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            heroTag: 'sendMessage',
            backgroundColor: theme.colors.buttonColor,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if (!state.editingFlag && state.descriptionController!.text.isNotEmpty) {
                context.read<ChatPageCubit>().add(isTask, topic);
              } else if (state.descriptionController!.text.isNotEmpty) {
                context.read<ChatPageCubit>().finishEditing(false);
              }
            },
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 18,
            ),
            elevation: 0,
          ),
        ],
      ),
    );
  }
}
