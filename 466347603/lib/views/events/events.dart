import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/page_info.dart';
import '../home/home_cubit.dart';
import 'events_cubit.dart';

class EventsScreen extends StatelessWidget {
  late final FocusNode _messageFocusNode;
  late final FocusNode _searchFocusNode;
  late final TextEditingController _messageController;
  late final TextEditingController _searchController;

  EventsScreen({Key? key}) : super(key: key) {
    _messageFocusNode = FocusNode();
    _searchFocusNode = FocusNode();
    _messageController = TextEditingController();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final page = ModalRoute.of(context)!.settings.arguments as PageInfo;
    context.read<EventsCubit>().init(page);
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(context),
          body: GestureDetector(
            onTap: () {
              context.read<EventsCubit>()
                ..changeEditMode(false)
                ..unselectEvents();
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                context.read<EventsCubit>().state.showEvents.isEmpty
                    ? _hintMessageBox(context)
                    : _eventList(context),
                _messageBar(context),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar(BuildContext context) {
    final state = context.read<EventsCubit>().state;
    return AppBar(
      leading: state.isSearchMode
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  context.read<EventsCubit>()..changeSearchMode(false),
            )
          : const BackButton(),
      title: state.isSearchMode
          ? TextField(
              onChanged: (query) =>
                  context.read<EventsCubit>().updateSearchQuery(query),
              style: const TextStyle(color: Colors.white),
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
                hintText: 'Enter event',
                hintStyle: TextStyle(
                  color: Colors.white54,
                ),
              ),
            )
          : Center(child: Text(state.page!.title)),
      actions: _appBarActions(context),
    );
  }

  List<Widget> _appBarActions(BuildContext context) {
    final state = context.read<EventsCubit>().state;
    if (state.isEditMode) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.reply),
          onPressed: () => _replyEvents(context),
        ),
        if (state.selectedEvents.length == 1 &&
            state.showEvents[state.selectedEvents[0]].message != '')
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editEvent(context),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _copyEvent(context),
              ),
            ],
          ),
        IconButton(
          icon: state.showEvents[state.selectedEvents[0]].isBookmarked
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_border),
          onPressed: () => _bookmarkEvent(context),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteEvent(context),
        ),
      ];
    } else {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            state.isSearchMode
                ? {
                    FocusScope.of(context).unfocus(),
                  }
                : {
                    _searchFocusNode.requestFocus(),
                    _searchController.clear(),
                    context.read<EventsCubit>().changeSearchMode(true),
                  };
          },
        ),
        IconButton(
          icon: state.isBookmarkedOnly
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_border),
          onPressed: () => context.read<EventsCubit>().changeBookmarkedOnly(),
        ),
      ];
    }
  }

  void _replyEvents(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select the page you want '
                'to migrate the selected '
                'event(s) to!',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 15),
              BlocBuilder<EventsCubit, EventsState>(
                builder: (context, state) {
                  return Container(
                    height: 200,
                    width: 300,
                    child: ListView.builder(
                      itemCount: context.read<HomeCubit>().state.pages.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              width: 80,
                              child: RadioListTile<int>(
                                activeColor: Theme.of(context).accentColor,
                                value: index,
                                groupValue: context
                                    .read<EventsCubit>()
                                    .state
                                    .replyPageIndex,
                                onChanged: (value) {
                                  final page = context
                                      .read<HomeCubit>()
                                      .state
                                      .pages[index];
                                  context
                                      .read<EventsCubit>()
                                      .changeReplyPage(page, value as int);
                                },
                              ),
                            ),
                            Expanded(
                              child: Text(
                                context
                                    .read<HomeCubit>()
                                    .state
                                    .pages[index]
                                    .title,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: ElevatedButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: () {
                  context.read<EventsCubit>().replyEvents(context);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _editEvent(BuildContext context) {
    final state = context.read<EventsCubit>().state;
    _messageFocusNode.requestFocus();
    _messageController.text = state.showEvents[state.selectedEvents[0]].message;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
    context.read<EventsCubit>()
      ..changeEditMode(false)
      ..changeIsMessageEdit(true);
  }

  void _copyEvent(BuildContext context) {
    context.read<EventsCubit>().copyEvent();
  }

  void _bookmarkEvent(BuildContext context) {
    context.read<EventsCubit>().bookMarkEvent();
  }

  void _deleteEvent(BuildContext context) {
    context.read<EventsCubit>().deleteEvent();
  }

  Widget _hintMessageBox(BuildContext context) {
    final state = context.read<EventsCubit>().state;
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 25,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
            ),
            child: context.read<EventsCubit>().state.isSearchMode
                ? Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 40,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 35,
                        ),
                        color: Theme.of(context).dialogBackgroundColor,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.search,
                              size: 48,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Please enter a search query to begin searching',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                          text: 'This is the page where you can track '
                              'everything about "${state.page!.title}"!\n\n',
                          style: Theme.of(context).primaryTextTheme.bodyText1,
                        ),
                        TextSpan(
                          text:
                              'Add you first event to "${state.page!.title}" page by '
                              'entering some text in the text box below '
                              'and hitting the send button. Tap on the '
                              'bookmark icon on the top right corner to '
                              'show the bookmarked events only.',
                          style: Theme.of(context).primaryTextTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _eventList(BuildContext context) {
    final state = context.read<EventsCubit>().state;
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: state.showEvents.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.read<EventsCubit>().selectEvent(index),
            onLongPress: () {
              context.read<EventsCubit>()
                ..changeEditMode(true)
                ..selectEvent(index);
            },
            child: Row(
              children: [
                _eventListElement(index, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _eventListElement(int index, BuildContext context) {
    final state = context.read<EventsCubit>().state;
    final event = state.showEvents[index];
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: state.selectedEvents.contains(index)
            ? Theme.of(context).selectedRowColor
            : Theme.of(context).dialogBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (event.categoryId != 0)
            Row(
              children: [
                Icon(state.categories[event.categoryId].icon),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  state.categories[event.categoryId].title,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          const SizedBox(height: 5),
          event.message != ''
              ? LimitedBox(
                  maxWidth: 320,
                  child: Text(
                    event.message,
                  ),
                )
              : Container(
                  width: 150,
                  height: 150,
                  child: Image.file(File(event.imagePath)),
                ),
          const SizedBox(height: 5),
          Row(
            children: [
              if (event.isBookmarked)
                Icon(
                  Icons.bookmark,
                  color: Colors.orange[600],
                  size: 15,
                ),
              const SizedBox(width: 5),
              Text(event.formattedSendTime),
            ],
          ),
        ],
      ),
    );
  }

  Widget _messageBar(BuildContext context) {
    final state = context.read<EventsCubit>().state;
    return Container(
      margin: const EdgeInsets.all(7),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: Theme.of(context).accentIconTheme.color,
            ),
            onPressed: () => _addImageEvent(context),
          ),
          IconButton(
            icon: Icon(
              state.categories[state.categoryIndex].icon,
              color: Theme.of(context).accentIconTheme.color,
            ),
            onPressed: () {
              _showCategoryList(context);
            },
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: TextField(
                focusNode: _messageFocusNode,
                controller: _messageController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                  hintText: 'Enter event',
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).accentIconTheme.color,
            ),
            onPressed: () => _addMessageEvent(context),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _showCategoryList(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(10),
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: context.read<EventsCubit>().state.categories.length,
            itemBuilder: (context, index) {
              return Container(
                width: 70,
                child: GestureDetector(
                  onTap: () {
                    context.read<EventsCubit>().changeCategory(index);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        child: Icon(
                          context
                              .read<EventsCubit>()
                              .state
                              .categories[index]
                              .icon,
                          color: Colors.white,
                        ),
                        radius: 30,
                        backgroundColor: Theme.of(context).cardColor,
                      ),
                      Text(
                        context
                            .read<EventsCubit>()
                            .state
                            .categories[index]
                            .title,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _addImageEvent(BuildContext context) {
    context.read<EventsCubit>().addImageEvent();
  }

  void _addMessageEvent(BuildContext context) {
    context.read<EventsCubit>().addMessageEvent(_messageController.text);
    FocusScope.of(context).unfocus();
    _messageController.clear();
  }
}
