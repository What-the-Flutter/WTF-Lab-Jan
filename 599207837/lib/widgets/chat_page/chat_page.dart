import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/database.dart' as db;
import '../../entity/entities.dart' as entity;
import '../../main.dart';
import '../widgets.dart' as custom;
import 'chat_page_cubit.dart';
import 'chat_page_state.dart';

class ChatPage extends StatelessWidget {
  final entity.Topic topic;
  final Function onChange;

  ChatPage({required this.topic, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatPageCubit()..getElements(topic),
      child: _ChatPage(
        topic: topic,
        onChange: onChange,
      ),
    );
  }
}

class _ChatPage extends StatelessWidget {
  final entity.Topic topic;
  final _scrollController = ScrollController();
  final Function onChange;

  _ChatPage({required this.topic, required this.onChange});

  void _onScrollEvent(BuildContext context) {
    final pixels = _scrollController.position.pixels;
    if (pixels >= _scrollController.position.maxScrollExtent - 40) {
      context.read<ChatPageCubit>().loadElements(topic);
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() => _onScrollEvent(context));
    final themeInherited = ThemeInherited.of(context)!;
    return BlocBuilder<ChatPageCubit, ChatPageState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: themeInherited.preset.colors.backgroundColor,
          appBar: _chatAppBar(themeInherited, context),
          body: Column(
            children: <Widget>[
              if (state.selectionFlag)
                Container(
                  decoration: BoxDecoration(color: themeInherited.preset.colors.backgroundColor),
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
                            custom.Alerts.moveAlert(
                              context: context,
                              themeInherited: themeInherited,
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
                child: FutureBuilder<List<entity.Message>>(
                  future: db.MessageLoader.loadElements(topic),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: state.elements!.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return custom.ChatMessage(
                            key: Key(state.elements![index].uuid.toString()),
                            item: state.elements![index],
                            onDeleted: () => context.read<ChatPageCubit>().deleteMessage(index),
                            onEdited: () => context
                                .read<ChatPageCubit>()
                                .startEditing(index, state.elements![index]),
                            onSelection: () => context.read<ChatPageCubit>().setSelection(true),
                            onSelected: () =>
                                context.read<ChatPageCubit>().onSelect(state.elements![index]),
                            selection: state.selectionFlag,
                            themeInherited: themeInherited,
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              _inputForm(state, context),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _chatAppBar(ThemeInherited themeInherited, BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: themeInherited.preset.colors.themeColor2,
      flexibleSpace: SafeArea(
        child: BlocBuilder<ChatPageCubit, ChatPageState>(
          builder: (context, state) {
            return state.searchPage
                ? _searchBarRow(context, themeInherited, state)
                : _defaultAppBarRow(context, themeInherited);
          },
        ),
      ),
    );
  }

  Widget _searchBarRow(BuildContext context, ThemeInherited themeInherited, ChatPageState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(color: themeInherited.preset.colors.textColor1),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 5, left: 10),
                hintText: 'Search...',
                hintStyle: TextStyle(color: themeInherited.preset.colors.minorTextColor),
                filled: true,
                fillColor: themeInherited.preset.colors.themeColor2,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: themeInherited.preset.colors.minorTextColor,
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: themeInherited.preset.colors.underlineColor,
                    width: 0.5,
                  ),
                ),
              ),
              controller: state.searchController,
            ),
          ),
        ),
        IconButton(
          onPressed: () => context.read<ChatPageCubit>().hideSearchBar(),
          icon: Icon(
            Icons.close_rounded,
            color: themeInherited.preset.colors.iconColor2,
          ),
        ),
      ],
    );
  }

  Widget _defaultAppBarRow(BuildContext context, ThemeInherited themeInherited) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () {
            context.read<ChatPageCubit>().onChatExit(topic);
            onChange();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: themeInherited.preset.colors.iconColor2,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        CircleAvatar(
          backgroundColor: themeInherited.preset.colors.avatarColor,
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
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: themeInherited.preset.colors.textColor2,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                'Online',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded),
          color: themeInherited.preset.colors.iconColor2,
          tooltip: 'Search messages',
          onPressed: () => context.read<ChatPageCubit>().buildSearchBar(),
        ),
        IconButton(
          icon: const Icon(Icons.brightness_4_rounded),
          color: themeInherited.preset.colors.iconColor2,
          tooltip: 'Change theme',
          onPressed: () {
            themeInherited.changeTheme();
          },
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
    final themeInherited = ThemeInherited.of(context)!;
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
      width: double.infinity,
      color: themeInherited.preset.colors.themeColor2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 40,
            child: FloatingActionButton(
              heroTag: 'changeAddedType',
              backgroundColor: themeInherited.preset.colors.buttonColor,
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
                      return custom.DateTimePicker(
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
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                      ),
                      controller: state.descriptionController,
                      style: TextStyle(color: themeInherited.preset.colors.textColor2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Container(
            height: 40,
            child: FloatingActionButton(
              heroTag: 'sendMessage',
              backgroundColor: themeInherited.preset.colors.buttonColor,
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
    );
  }

  Widget _defaultInputForm(bool isTask, ChatPageState state, BuildContext context) {
    final decorator = ThemeInherited.of(context)!;
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
      height: 60,
      width: double.infinity,
      color: decorator.preset.colors.themeColor2,
      child: Row(
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'changeAddedType',
            backgroundColor: decorator.preset.colors.buttonColor,
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
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: InputBorder.none,
              ),
              controller: state.descriptionController,
              style: TextStyle(color: decorator.preset.colors.textColor2),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            heroTag: 'sendMessage',
            backgroundColor: decorator.preset.colors.buttonColor,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if (!state.editingFlag && state.descriptionController!.text.isNotEmpty) {
                context.read<ChatPageCubit>().add(
                      isTask,
                      topic,
                    );
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
