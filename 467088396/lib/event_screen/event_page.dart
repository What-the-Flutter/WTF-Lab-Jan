import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../home_screen/home_cubit.dart';
import '../models/category.dart';
import '../models/event.dart';
import '../models/section.dart';
import 'event_cubit.dart';
import 'event_state.dart';

class EventPage extends StatefulWidget {
  final Category category;

  EventPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(category: category);
}

class _EventPageState extends State<EventPage> {
  final Category category;
  final _controller = TextEditingController();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _eventFocusNode = FocusNode();
  bool _isEditingText = false;
  File? _imageFile;

  _EventPageState({required this.category});

  @override
  void initState() {
    BlocProvider.of<EventCubit>(context).init(category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(state, category.name),
          body: _eventBody(state),
          resizeToAvoidBottomInset: true,
        );
      },
    );
  }

  Column _eventBody(EventState state) {
    var searchedEventList = state.isSearchMode
        ? state.category!.eventList
            .where((element) =>
                element.text.contains(_searchController.text.toLowerCase()))
            .toList()
        : state.category!.eventList;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: state.isSearchMode
          ? <Widget>[_eventList(searchedEventList, state)]
          : <Widget>[
              _eventList(searchedEventList, state),
              _bottomInput(state),
            ],
    );
  }

  Expanded _eventList(List<Event> searchedEventList, EventState state) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: defaultPadding / 2),
        reverse: true,
        itemCount: searchedEventList.length,
        itemBuilder: (context, index) {
          return _eventMessage(searchedEventList[index], state, index);
        },
      ),
    );
  }

  AppBar _appBar(EventState state, String title) {
    return AppBar(
      elevation: 15,
      leading:
          state.isEditMode ? _cancelButton(state) : _arrowBackButton(state),
      shadowColor: primaryColor,
      title: state.isSearchMode
          ? _searchTextFiled(state)
          : _setAppBarTitle(title, state),
      actions: state.isEditMode
          ? _editModeAppBarActions(state)
          : _appBarActions(state),
    );
  }

  Text _setAppBarTitle(String title, EventState state) {
    return Text(
      state.isEditMode ? '${state.selectedEvent.length}' : title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
        letterSpacing: 2,
        fontSize: 26,
      ),
    );
  }

  List<Widget> _editModeAppBarActions(EventState state) {
    return [
      IconButton(
        icon: const Icon(
          Icons.reply,
          color: Colors.white,
          size: 28,
        ),
        onPressed: () => _replyEvents(state),
      ),
      IconButton(
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 28,
        ),
        onPressed: () => _editEvent,
      ),
      IconButton(
        icon: const Icon(
          Icons.copy,
          color: Colors.white,
          size: 28,
        ),
        onPressed: () {
          BlocProvider.of<EventCubit>(context).copyEvent();
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.bookmark_border,
          color: Colors.white,
          size: 28,
        ),
        onPressed: () {
          BlocProvider.of<EventCubit>(context).bookmarkEvent();
        },
      ),
      IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            BlocProvider.of<EventCubit>(context).deleteEvent();
          }),
    ];
  }

  IconButton _cancelButton(EventState state) {
    return IconButton(
      icon: const Icon(
        Icons.close,
        color: Colors.white,
        size: 28,
      ),
      onPressed: () {
        BlocProvider.of<EventCubit>(context).unselectEvents();
        BlocProvider.of<EventCubit>(context).setEditMode(false);
      },
    );
  }

  IconButton _arrowBackButton(EventState state) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: Colors.white,
        size: 28,
      ),
      onPressed: () {
        if (state.isSearchMode) {
          BlocProvider.of<EventCubit>(context).setSearchMode(false);
          BlocProvider.of<EventCubit>(context).setWritingState(false);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  List<Widget>? _appBarActions(EventState state) {
    var appBarActions = <Widget>[];
    if (!state.isSearchMode) {
      appBarActions.add(
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            _searchFocusNode.requestFocus();
            BlocProvider.of<EventCubit>(context).setSearchMode(true);
          },
        ),
      );
    }
    if (state.isWriting && state.isSearchMode) {
      appBarActions.add(IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.white,
          size: 28,
        ),
        onPressed: () {
          BlocProvider.of<EventCubit>(context).setWritingState(false);
          _searchController.clear();
        },
      ));
    }

    return appBarActions;
  }

  Widget _searchTextFiled(EventState state) {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      style: const TextStyle(color: Colors.white),
      onChanged: (value) => value.isEmpty
          ? BlocProvider.of<EventCubit>(context).setWritingState(false)
          : BlocProvider.of<EventCubit>(context).setWritingState(true),
      decoration: InputDecoration(
        hintText: 'Search in ${state.category!.name}',
        hintStyle: const TextStyle(color: Colors.white),
        border: InputBorder.none,
      ),
    );
  }

  Widget _bottomInput(EventState state) {
    var insert = true;
    return Container(
      margin: const EdgeInsets.only(
        bottom: defaultPadding,
        left: 5,
      ),
      child: Row(
        children: <Widget>[
          _bubbleChartIconButton(state),
          _eventTextFiled(),
          _sendEventIconButton(insert),
        ],
      ),
    );
  }

  Widget _sectionsList(EventState state) {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sections.length,
          itemBuilder: (context, index) {
            return _sectionItem(state, index);
          }),
    );
  }

  Widget _sectionItem(EventState state, int index) {
    var section = Section(
      title: sections.keys.elementAt(index),
      iconData: sections.values.elementAt(index),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              section.iconData,
              color: secondColor,
              size: 32,
            ),
            onPressed: () {
              BlocProvider.of<EventCubit>(context).setSection(section);
              Navigator.pop(context);
            },
          ),
          Text(section.title),
        ],
      ),
    );
  }

  IconButton _sendEventIconButton(bool insert) {
    return IconButton(
      onPressed: () {
        if (insert && !_isEditingText) {
          BlocProvider.of<EventCubit>(context)
              .addMessageEvent(_controller.text);
        }
        _controller.text = '';
      },
      icon: const Icon(
        Icons.send_rounded,
        color: secondColor,
        size: 32,
      ),
    );
  }

  IconButton _bubbleChartIconButton(EventState state) {
    return IconButton(
      onPressed: () {
        _showSectionList(state);
      },
      icon: Icon(
        state.selectedSection!.iconData,
        color: secondColor,
        size: 32,
      ),
    );
  }

  Future<dynamic> _showSectionList(EventState state) {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return Container(
          height: 70,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: _sectionsList(state),
        );
      },
    );
  }

  Container _eventTextFiled() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            spreadRadius: 5,
            blurRadius: 5,
            offset: const Offset(5, 5),
            color: primaryColor.withOpacity(0.10),
          ),
        ],
      ),
      width: 290,
      child: TextField(
        controller: _controller,
        focusNode: _eventFocusNode,
        onChanged: (value) {},
        decoration: const InputDecoration(
          hintText: 'Enter Event',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _eventMessage(Event event, EventState state, int index) {
    return GestureDetector(
      onLongPress: () {
        BlocProvider.of<EventCubit>(context).setEditMode(true);
        BlocProvider.of<EventCubit>(context).selectEvent(index);
      },
      onTap: () {
        BlocProvider.of<EventCubit>(context).selectEvent(index);
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: defaultPadding / 2,
          right: defaultPadding * 10,
          top: defaultPadding / 2,
          bottom: defaultPadding / 2,
        ),
        padding: const EdgeInsets.all(defaultPadding / 2),
        decoration: BoxDecoration(
          color: state.selectedEvent.contains(index)
              ? primaryColor.withOpacity(0.2)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(5, 5),
              color: primaryColor.withOpacity(0.10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textMessage(event),
            _eventMessageInfo(event),
          ],
        ),
      ),
    );
  }

  Widget _textMessage(Event event) {
    var text = Text(
      event.text,
      style: const TextStyle(
        fontSize: 18,
      ),
    );
    if (event.section != null) {
      return Row(
        children: [
          Icon(
            event.section!.iconData,
            color: secondColor,
          ),
          const SizedBox(width: 5),
          text,
        ],
      );
    }
    return text;
  }

  Row _eventMessageInfo(Event event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: event.isBookmarked
          ? [
              Text(
                _calculateTime(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              IconButton(
                  onPressed: () {
                    event.isBookmarked = false;
                  },
                  icon: const Icon(
                    Icons.bookmark_rounded,
                    color: secondColor,
                    size: 22,
                  )),
            ]
          : [
              Text(
                _calculateTime(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
    );
  }

  String _calculateTime() => DateFormat('hh:mm a').format(DateTime.now());

  Future<void> _getFromGallery() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
    }
  }

  void _editEvent(EventState state) {
    _eventFocusNode.requestFocus();
    _controller.text = state.category!.eventList[state.selectedEvent[0]].text;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    BlocProvider.of<EventCubit>(context).setEditMode(false);
    BlocProvider.of<EventCubit>(context).unselectEvents();
  }

  void _replyEvents(EventState state) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Text(
                  'Select the page you want '
                  'to migrate the selected '
                  'event(s) to!',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<EventCubit, EventState>(
                builder: (context, state) {
                  return Container(
                    height: 200,
                    width: 300,
                    child: _replyEventListView(state),
                  );
                },
              ),
              _replyDialogButtons(state),
            ],
          ),
        );
      },
    );
  }

  ListView _replyEventListView(EventState state) {
    return ListView.builder(
      itemCount: context.read<HomeCubit>().state.categoryList.length,
      itemBuilder: (context, index) {
        return RadioListTile<int>(
          title: Text(
            context.read<HomeCubit>().state.categoryList[index].name,
          ),
          activeColor: Theme.of(context).primaryColor,
          value: index,
          groupValue: state.replyCategoryIndex,
          onChanged: (value) => context
              .read<EventCubit>()
              .setReplyCategory(context, value as int),
        );
      },
    );
  }

  Widget _replyDialogButtons(EventState state) {
    return Row(
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<EventCubit>(context).replyEvents(context);
            Navigator.pop(context);
          },
          child: Text(
            'Move',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            ),
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
