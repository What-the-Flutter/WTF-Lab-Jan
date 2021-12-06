import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../domain/entities/event.dart';
import '../../home/cubit/home_page_cubit.dart';
import '../cubit/event_page_cubit.dart';

class EventScreen extends StatelessWidget {
  EventScreen({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EventPageCubit>();
    cubit.init(event);
    return BlocBuilder<EventPageCubit, EventPageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(state, context),
          body: GestureDetector(
            onTap: () {
              cubit
                ..setEditMode(false)
                ..unselectEventElements();
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                state.event!.events.isEmpty ? _hintMessageBox(context) : _eventElementList(context),
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
          : Center(child: Text(state.event!.title)),
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
        if (state.selectedEventElements.length == 1 &&
            state.event!.events[state.selectedEventElements[0]].message != null)
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
          icon: state.event!.events[state.selectedEventElements[0]].isBookmarked
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
          icon: state.isBookmarked ? const Icon(Icons.bookmark) : const Icon(Icons.bookmark_border),
          onPressed: () => context.read<EventPageCubit>().changeBookmarked(),
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
                                activeColor: Colors.green,
                                value: index,
                                groupValue: context.read<EventPageCubit>().state.replyEventIndex,
                                onChanged: (value) => context
                                    .read<EventPageCubit>()
                                    .setReplyEventElement(context, value as int),
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
                  context.read<EventPageCubit>().replyEventElements(context);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _editSlidableEventElement(BuildContext context, {required int index}) {
    final cubit = context.read<EventPageCubit>();
    cubit.messageFocusNode.requestFocus();
    cubit.messageController.text = cubit.state.event!.events[index].message!;
    cubit.setEditMode(false);
    cubit.setEventElementEdit(true);
  }

  void _editEvent(BuildContext context) {
    final cubit = context.read<EventPageCubit>();
    cubit.messageFocusNode.requestFocus();
    cubit.messageController.text =
        cubit.state.event!.events[cubit.state.selectedEventElements.first].message!;
    cubit.messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: cubit.messageController.text.length),
    );
    context.read<EventPageCubit>()
      ..setEditMode(false)
      ..setEventElementEdit(true);
  }

  void _copyEvent(BuildContext context) {
    context.read<EventPageCubit>().copyEventElement();
  }

  void _bookmarkEvent(BuildContext context) {
    context.read<EventPageCubit>().bookMarkEventElements();
  }

  void _deleteSlidableEventElement(BuildContext context, {required int index}) {
    final cubit = context.read<EventPageCubit>();
    var currentEventElement = cubit.state.selectedEventElements[index];
    var updatedEvent = Event.from(cubit.state.event!);
    updatedEvent.events.removeAt(currentEventElement);
    cubit.setEditMode(false);
    cubit.state.copyWith(event: updatedEvent);
  }

  void _deleteEvent(BuildContext context) {
    context.read<EventPageCubit>().deleteEventElements();
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
                              'everything about "${state.event!.title}"!\n\n',
                          style: Theme.of(context).primaryTextTheme.bodyText1,
                        ),
                        TextSpan(
                          text: 'Add you first event to "${state.event!.title}" page by '
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

  Widget _eventElementList(BuildContext context) {
    final cubit = context.read<EventPageCubit>();
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: cubit.state.event!.events.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: const ValueKey(0),
            //from left to right
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    _editSlidableEventElement(context, index: index);
                  },
                  backgroundColor: const Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
              ],
            ),
            // from right to left
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    _deleteSlidableEventElement(context, index: index);
                  },
                  backgroundColor: const Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => context.read<EventPageCubit>().selectEventElements(index),
              onLongPress: () {
                context.read<EventPageCubit>()
                  ..setEditMode(true)
                  ..selectEventElements(index);
              },
              child: Row(
                children: [
                  if (cubit.state.event!.events[index].isBookmarked ||
                      !cubit.state.isBookmarked ||
                      context
                          .read<EventPageCubit>()
                          .isSearchSuggestion(index, cubit.searchController.text))
                    _eventListElement(index, context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _eventListElement(int index, BuildContext context) {
    final cubit = context.read<EventPageCubit>();
    final event = cubit.state.event!.events[index];
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: cubit.state.selectedEventElements.contains(index)
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
              !context
                  .read<EventPageCubit>()
                  .isSearchSuggestion(index, cubit.searchController.text))
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
            icon: Icon(
              context.read<EventPageCubit>().state.currentCategory.icon,
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
          BlocBuilder<EventPageCubit, EventPageState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () => _addEventElement(context),
                icon: state.isAvailableForSend
                    ? const Icon(
                        Icons.send,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.add_a_photo,
                        color: Colors.green,
                      ),
              );
            },
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

  void _addEventElement(BuildContext context) {
    final cubit = context.read<EventPageCubit>();
    cubit.state.isAvailableForSend ? _addMessageEvent(context) : _addImageEvent(context);
  }

  void _addImageEvent(BuildContext context) {
    context.read<EventPageCubit>().addEventElementImage();
  }

  void _addMessageEvent(BuildContext context) {
    final cubit = context.read<EventPageCubit>();
    context.read<EventPageCubit>().addEventElementMessage(cubit.messageController.text);
    FocusScope.of(context).unfocus();
    cubit.messageController.clear();
  }
}
