import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/event.dart';
import '../../home/cubit/home_page_cubit.dart';
import '../cubit/event_page_cubit.dart';

class EventScreen extends StatelessWidget {
  EventScreen({Key? key, required this.event}) : super(key: key);

  final Event? event;

  @override
  Widget build(BuildContext context) {
    context.read<EventPageCubit>().init(event!);
    return BlocBuilder<EventPageCubit, EventPageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(state, context),
          body: GestureDetector(
            onTap: () {
              context.read<EventPageCubit>()
                ..setEditMode(false)
                ..unselectEvents();
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                state.page!.events.isEmpty ? _hintMessageBox(context) : _eventList(context),
                _messageBar(context),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar(EventPageState state, BuildContext context) {
    return AppBar(
      leading: state.isSearchMode
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.read<EventPageCubit>().setSearchMode(false),
            )
          : const BackButton(),
      title: context.read<EventPageCubit>().state.isSearchMode
          ? TextField(
              style: const TextStyle(color: Colors.white),
              controller: context.read<EventPageCubit>().searchController,
              focusNode: context.read<EventPageCubit>().searchFocusNode,
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
    final state = context.read<EventPageCubit>().state;
    if (state.isEditMode) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.reply),
          onPressed: () => _replyEvents(context),
        ),
        if (state.selectedEvents.length == 1 &&
            state.page!.events[state.selectedEvents[0]].message != null)
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
          icon: state.page!.events[state.selectedEvents[0]].isBookmarked
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
            context.read<EventPageCubit>().state.isSearchMode
                ? {
                    FocusScope.of(context).unfocus(),
                  }
                : {
                    context.read<EventPageCubit>().searchFocusNode.requestFocus(),
                    context.read<EventPageCubit>().searchController.clear(),
                    context.read<EventPageCubit>().setSearchMode(true),
                  };
          },
        ),
        IconButton(
          icon: state.isBookmarkedOnly
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_border),
          onPressed: () => context.read<EventPageCubit>().changeBookmarkedOnly(),
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
              BlocBuilder<EventPageCubit, EventPageState>(
                builder: (context, state) {
                  return Container(
                    height: 200,
                    width: 300,
                    child: ListView.builder(
                      itemCount: context.read<HomePageCubit>().state.events.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              width: 80,
                              child: RadioListTile<int>(
                                activeColor: Theme.of(context).accentColor,
                                value: index,
                                groupValue: context.read<EventPageCubit>().state.replyPageIndex,
                                onChanged: (value) => context
                                    .read<EventPageCubit>()
                                    .setReplyPage(context, value as int),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                context.read<HomePageCubit>().state.events[index].title,
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
                  context.read<EventPageCubit>().replyEvents(context);
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
    final cubit = context.read<EventPageCubit>();
    cubit.messageFocusNode.requestFocus();
    cubit.messageController.text = cubit.state.page!.events[cubit.state.selectedEvents[0]].message!;
    cubit.messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: cubit.messageController.text.length),
    );
    context.read<EventPageCubit>()
      ..setEditMode(false)
      ..setMessageEdit(true);
  }

  void _copyEvent(BuildContext context) {
    context.read<EventPageCubit>().copyEvent();
  }

  void _bookmarkEvent(BuildContext context) {
    context.read<EventPageCubit>().bookMarkEvent();
  }

  void _deleteEvent(BuildContext context) {
    context.read<EventPageCubit>().deleteEvent();
  }

  Widget _hintMessageBox(BuildContext context) {
    final state = context.read<EventPageCubit>().state;
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
            child: context.read<EventPageCubit>().state.isSearchMode
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
                          text: 'Add you first event to "${state.page!.title}" page by '
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
    final cubit = context.read<EventPageCubit>();
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: cubit.state.page!.events.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.read<EventPageCubit>().selectEvent(index),
            onLongPress: () {
              context.read<EventPageCubit>()
                ..setEditMode(true)
                ..selectEvent(index);
            },
            child: Row(
              children: [
                if (cubit.state.page!.events[index].isBookmarked ||
                    !cubit.state.isBookmarkedOnly ||
                    context.read<EventPageCubit>().isSearchSuggest(index, cubit.searchController.text))
                  _eventListElement(index, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _eventListElement(int index, BuildContext context) {
    final cubit = context.read<EventPageCubit>();
    final event = cubit.state.page!.events[index];
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: cubit.state.selectedEvents.contains(index)
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
      child: (cubit.state.isSearchMode &&
              !context.read<EventPageCubit>().isSearchSuggest(index, cubit.searchController.text))
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (event.category != null)
                  Row(
                    children: [
                      Icon(event.category!.icon),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        event.category!.title,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                const SizedBox(height: 5),
                event.message != null
                    ? LimitedBox(
                        maxWidth: 320,
                        child: Text(
                          event.message!,
                        ),
                      )
                    : Container(
                        width: 150,
                        height: 150,
                        child: Image.file(event.image!),
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
                    Text(event.stringSendTime),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _messageBar(BuildContext context) {
    final cubit = context.read<EventPageCubit>();
    return Container(
      margin: const EdgeInsets.all(7),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.green),
            onPressed: () => _addImageEvent(context),
          ),
          IconButton(
            icon: Icon(
              context.read<EventPageCubit>().state.selectedCategory.icon,
              color: Colors.green,
            ),
            onPressed: () {
              _showCategoryList(context);
            },
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: TextField(
                focusNode: cubit.messageFocusNode,
                controller: cubit.messageController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                  hintText: 'Enter event',
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: Colors.green,
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
            itemCount: context.read<EventPageCubit>().state.categories.length,
            itemBuilder: (context, index) {
              return Container(
                width: 70,
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<EventPageCubit>()
                        .setCategory(context.read<EventPageCubit>().state.categories[index]);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        child: Icon(
                          context.read<EventPageCubit>().state.categories[index].icon,
                          color: Colors.white,
                        ),
                        radius: 30,
                        backgroundColor: Theme.of(context).cardColor,
                      ),
                      Text(context.read<EventPageCubit>().state.categories[index].title),
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
    context.read<EventPageCubit>().addImageEvent();
  }

  void _addMessageEvent(BuildContext context) {
    final cubit = context.read<EventPageCubit>();
    context.read<EventPageCubit>().addMessageEvent(cubit.messageController.text);
    FocusScope.of(context).unfocus();
    cubit.messageController.clear();
  }
}
