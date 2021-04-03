import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../common_widgets/custom_dialog.dart';
import '../../common_widgets/custom_drawer.dart';
import '../../db_helper/db_helper.dart';
import '../../models/event_message.dart';
import '../../models/font_size_customization.dart';
import '../event_screen/slidable_swipe_widget.dart';
import '../setting_screen/settings_screen_bloc.dart';
import 'timeline_bloc.dart';
import 'timeline_event.dart';
import 'timeline_screen_app_bar.dart';
import 'timeline_state.dart';

class TimeLineScreen extends StatefulWidget {
  final String title;

  TimeLineScreen({Key key, this.title}) : super(key: key);

  @override
  _TimeLineScreenState createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  final SlidableController slidableController = SlidableController();

  final DBHelper _dbHelper = DBHelper();

  _TimeLineScreenState();

  @override
  void initState() {
    BlocProvider.of<TimelineScreenBloc>(context).add(
      TimelineEventMessageListInit(),
    );
    BlocProvider.of<TimelineScreenBloc>(context).add(
      TimelineUpdateTagList(),
    );
    _dbHelper.initializeDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelineScreenBloc, TimelineScreenState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: TimelineScreenAppBar(),
          drawer: CustomDrawer(),
          body: _timelineScreenBody,
        );
      },
    );
  }

  GestureDetector get _timelineScreenBody {
    return GestureDetector(
      onTap: () => FocusScope.of(context).nextFocus(),
      child: Column(
        children: [
          _suggestionSelectionTopBar,
          BlocProvider.of<TimelineScreenBloc>(context)
                  .state
                  .isSearchIconButtonPressed
              ? Divider(
                  color: Colors.black54,
                  height: 0.5,
                  thickness: 0.5,
                )
              : Container(),
          _tagSelectionTopBar,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                child: _eventMessageListView,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container get _suggestionSelectionTopBar {
    return (BlocProvider.of<TimelineScreenBloc>(context)
                .state
                .suggestionList
                .isNotEmpty &&
            BlocProvider.of<TimelineScreenBloc>(context)
                .state
                .isSearchIconButtonPressed)
        ? Container(
            height: 65,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 7.0,
                direction: Axis.horizontal,
                children: BlocProvider.of<TimelineScreenBloc>(context)
                    .state
                    .suggestionList
                    .map(
                      (suggestion) => InputChip(
                        label: Text(suggestion.nameOfSuggestion),
                        labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        backgroundColor: Theme.of(context).cardTheme.color,
                        onPressed: () =>
                            _filterEventMessageListBySuggestionName(
                                suggestion.nameOfSuggestion),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        : Container();
  }

  Container get _tagSelectionTopBar {
    return (BlocProvider.of<TimelineScreenBloc>(context)
                .state
                .tagList
                .isNotEmpty &&
            BlocProvider.of<TimelineScreenBloc>(context)
                .state
                .isSearchIconButtonPressed)
        ? Container(
            height: 65,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 7.0,
                direction: Axis.horizontal,
                children: BlocProvider.of<TimelineScreenBloc>(context)
                    .state
                    .tagList
                    .map(
                      (tag) => InputChip(
                        label: Text(tag.tagText),
                        labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        backgroundColor: Theme.of(context).cardTheme.color,
                        onPressed: () => _filterEventMessageList(tag.tagText),
                        onDeleted: () =>
                            BlocProvider.of<TimelineScreenBloc>(context).add(
                                TimelineTagDeleted(
                                    tag,
                                    BlocProvider.of<TimelineScreenBloc>(context)
                                        .state
                                        .tagList)),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        : Container();
  }

  void _closeSearchTextField() {
    BlocProvider.of<TimelineScreenBloc>(context).add(
      TimelineSearchIconButtonUnpressed(
        BlocProvider.of<TimelineScreenBloc>(context).state.eventMessageList,
        BlocProvider.of<TimelineScreenBloc>(context)
            .state
            .isSearchIconButtonPressed,
      ),
    );
  }

  void _filterEventMessageList(String value) {
    BlocProvider.of<TimelineScreenBloc>(context).add(
      TimelineEventMessageListFiltered(
          BlocProvider.of<TimelineScreenBloc>(context).state.eventMessageList,
          value),
    );
    BlocProvider.of<TimelineScreenBloc>(context).add(
      TimelineEventMessageListFilteredReceived(),
    );
  }

  void _filterEventMessageListBySuggestionName(String value) {
    BlocProvider.of<TimelineScreenBloc>(context).add(
      TimelineEventMessageListFilteredBySuggestionName(
          BlocProvider.of<TimelineScreenBloc>(context).state.eventMessageList,
          value),
    );
    BlocProvider.of<TimelineScreenBloc>(context).add(
      TimelineEventMessageListFilteredReceived(),
    );
  }

  Widget get _eventMessageListView {
    return BlocProvider.of<TimelineScreenBloc>(context)
            .state
            .filteredEventMessageList
            .isNotEmpty
        ? ListView.builder(
            reverse: true,
            padding: EdgeInsets.only(top: 15.0),
            itemCount: BlocProvider.of<TimelineScreenBloc>(context)
                .state
                .filteredEventMessageList
                .length,
            itemBuilder: (context, index) {
              final eventMessage = BlocProvider.of<TimelineScreenBloc>(context)
                  .state
                  .filteredEventMessageList[index];
              return _eventAndFavoriteMessage(eventMessage);
            },
          )
        : Center(
            child: Text(
              'No  event messages',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 17.0,
              ),
            ),
          );
  }

  Widget _eventAndFavoriteMessage(EventMessage eventMessage) {
    if ((eventMessage.isFavorite == 1 &&
            BlocProvider.of<TimelineScreenBloc>(context)
                .state
                .isFavoriteButPressed) ||
        (!BlocProvider.of<TimelineScreenBloc>(context)
            .state
            .isFavoriteButPressed)) {
      return SwipeWidget(
        child: BlocProvider.of<SettingScreenBloc>(context)
                .state
                .isLeftBubbleAlignment
            ? _eventMessageRightAlignment(eventMessage, false)
            : _eventMessageLeftAlignment(eventMessage, false),
        doSwipeSelectedAction: (action) =>
            doSwipeSelectedItemAction(context, eventMessage, action),
        isImageMessage: eventMessage.isImageMessage == 1,
        slidableController: slidableController,
      );
    } else {
      return Container();
    }
  }

  void doSwipeSelectedItemAction(BuildContext context,
      EventMessage eventMessage, SwipeSelectedAction action) {
    BlocProvider.of<TimelineScreenBloc>(context).state.selectedEventMessage =
        eventMessage;
    switch (action) {
      case SwipeSelectedAction.edit:
        _editEventMessage();
        break;
      case SwipeSelectedAction.delete:
        _showDeleteAlertCustomDialog();
        break;
      default:
        break;
    }
  }

  Future<Object> _showDeleteAlertCustomDialog() {
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      transitionDuration: Duration(milliseconds: 800),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.linearToEaseOut,
            reverseCurve: Curves.easeOutCubic,
          ),
          child: CustomDialog.deleteEventMessage(
            title: 'Delete event message',
            content: 'Are you want to delete this event message?',
            firstBtnText: 'Cancel',
            secondBtnText: 'Delete',
            icon: Icon(
              Icons.delete,
              color: Colors.white,
              size: 60,
            ),
            firstBtnFunc: _selectedCancel,
            secondBtnFunc: _deleteEventMessage,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return null;
      },
    );
  }

  Widget _eventMessageLeftAlignment(
      EventMessage eventMessage, bool isSelected) {
    return GestureDetector(
      onLongPress: () {
        isSelected ? () {} : _bottomSheet(context, eventMessage);
      },
      child: Row(
        children: [
          Expanded(
              flex: eventMessage.nameOfCategory == null ? 0 : 2,
              child: eventMessage.nameOfCategory == null
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(left: 5.0),
                      padding: EdgeInsets.only(
                        left: 5.0,
                      ),
                      height: 40,
                      child: Image.asset(eventMessage.categoryImagePath),
                    )),
          Expanded(
            flex: 10,
            child: Container(
              margin: EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
                left: 10.0,
              ),
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventMessage.nameOfSuggestion,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.orangeAccent.shade100,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    eventMessage.isImageMessage == 1
                        ? Image(image: FileImage(File(eventMessage.imagePath)))
                        : Text(
                            eventMessage.text,
                            maxLines: isSelected ? 1 : null,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 17.0,
                            ),
                          ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      eventMessage.time,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: isSelected
                ? Container()
                : IconButton(
                    icon: eventMessage.isFavorite == 1
                        ? Icon(
                            Icons.bookmark,
                            color: Colors.orangeAccent,
                          )
                        : Icon(
                            Icons.bookmark_border_outlined,
                            color: Theme.of(context).buttonColor,
                          ),
                    onPressed: () {
                      BlocProvider.of<TimelineScreenBloc>(context).add(
                        TimelineEventMessageToFavorite(eventMessage),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _eventMessageRightAlignment(
      EventMessage eventMessage, bool isSelected) {
    return GestureDetector(
      onLongPress: () {
        isSelected ? () {} : _bottomSheet(context, eventMessage);
      },
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: isSelected
                ? Container()
                : IconButton(
                    icon: eventMessage.isFavorite == 1
                        ? Icon(
                            Icons.bookmark,
                            color: Colors.orangeAccent,
                          )
                        : Icon(
                            Icons.bookmark_border_outlined,
                            color: Theme.of(context).buttonColor,
                          ),
                    onPressed: () {
                      BlocProvider.of<TimelineScreenBloc>(context).add(
                        TimelineEventMessageToFavorite(eventMessage),
                      );
                    },
                  ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              margin: EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
                right: 10.0,
              ),
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                ),
              ),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventMessage.nameOfSuggestion,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.orangeAccent.shade100,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    eventMessage.isImageMessage == 1
                        ? Image(image: FileImage(File(eventMessage.imagePath)))
                        : Text(
                            eventMessage.text,
                            maxLines: isSelected ? 2 : null,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 17.0,
                            ),
                          ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      eventMessage.time,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: eventMessage.nameOfCategory == null ? 0 : 2,
            child: eventMessage.nameOfCategory == null
                ? Container()
                : Container(
                    margin: EdgeInsets.only(right: 5.0),
                    padding: EdgeInsets.only(
                      right: 5.0,
                    ),
                    height: 40,
                    child: Image.asset(eventMessage.categoryImagePath),
                  ),
          ),
        ],
      ),
    );
  }

  void _bottomSheet(BuildContext context, EventMessage eventMessage) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.0),
                topLeft: Radius.circular(25.0),
              ),
            ),
            child: _structureBottomSheet(eventMessage),
          );
        });
  }

  Widget _structureBottomSheet(EventMessage eventMessage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: eventMessage.isImageMessage == 1 ? 0 : 5,
          child: eventMessage.isImageMessage == 1
              ? Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Center(
                    child: Text(
                      'Image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                )
              : _eventMessageLeftAlignment(eventMessage, true),
        ),
        Expanded(
          flex: eventMessage.isImageMessage == 1 ? 0 : 3,
          child: eventMessage.isImageMessage == 1
              ? Container()
              : _listTile(
                  context,
                  'Copy',
                  Icons.copy,
                  _copyEventMessage,
                  eventMessage,
                ),
        ),
        Expanded(
          flex: eventMessage.isImageMessage == 1 ? 0 : 3,
          child: eventMessage.isImageMessage == 1
              ? Container()
              : _listTile(
                  context,
                  'Edit',
                  Icons.edit,
                  _editEventMessage,
                  eventMessage,
                ),
        ),
        Expanded(
          flex: eventMessage.isImageMessage == 1 ? 0 : 3,
          child: _listTile(
            context,
            eventMessage.isFavorite == 1
                ? 'Remove from favorites'
                : 'Add to favorites',
            Icons.bookmark_border_outlined,
            _addToFavorites,
            eventMessage,
          ),
        ),
        Expanded(
          flex: eventMessage.isImageMessage == 1 ? 0 : 3,
          child: _listTile(
            context,
            'Delete',
            Icons.delete,
            _deleteEventMessage,
            eventMessage,
          ),
        ),
      ],
    );
  }

  ListTile _listTile(BuildContext context, String name, IconData icon,
      Function action, EventMessage eventMessage) {
    BlocProvider.of<TimelineScreenBloc>(context)
        .add(TimelineEventMessageSelected(eventMessage));
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        name,
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
          fontSize: BlocProvider.of<SettingScreenBloc>(context)
                      .state
                      .fontSize ==
                  0
              ? listTileTitleSmallFontSize
              : BlocProvider.of<SettingScreenBloc>(context).state.fontSize == 1
                  ? listTileTitleDefaultFontSize
                  : listTileTitleLargeFontSize,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  void _copyEventMessage() {
    Clipboard.setData(
      ClipboardData(
          text: BlocProvider.of<TimelineScreenBloc>(context)
              .state
              .selectedEventMessage
              .text),
    );
  }

  void _editEventMessage() {
    _showEditEventMessageCustomDialog(
        BlocProvider.of<TimelineScreenBloc>(context)
            .state
            .selectedEventMessage);
  }

  Future<Object> _showEditEventMessageCustomDialog(EventMessage eventMessage) {
    BlocProvider.of<TimelineScreenBloc>(context).add(
      TimelineEditingModeChanged(true),
    );
    _textEditingController.text = eventMessage.text;
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      transitionDuration: Duration(milliseconds: 800),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.linearToEaseOut,
            reverseCurve: Curves.easeOutCubic,
          ),
          child: CustomDialog.editEventMessage(
            title: 'Edit the text',
            content: 'Edit your event message',
            firstBtnText: 'Cancel',
            secondBtnText: 'Save',
            icon: Icon(
              Icons.edit,
              color: Colors.white,
              size: 60,
            ),
            firstBtnFunc: _selectedCancel,
            secondBtnFunc: _selectedEdit,
            textEditControl: _textEditingController,
            eventMessage: eventMessage,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return null;
      },
    );
  }

  void _selectedCancel() {
    _textEditingController.clear();
    BlocProvider.of<TimelineScreenBloc>(context).add(
      TimelineEditingModeChanged(false),
    );
  }

  void _selectedEdit() {
    if (_textEditingController.text.isNotEmpty) {
      BlocProvider.of<TimelineScreenBloc>(context).add(
        TimelineEventMessageEdited(
          _textEditingController.text,
          BlocProvider.of<TimelineScreenBloc>(context).state.eventMessageList,
        ),
      );
      _textEditingController.clear();
    }
    BlocProvider.of<TimelineScreenBloc>(context).add(
      TimelineEditingModeChanged(false),
    );
  }

  void _addToFavorites() {
    BlocProvider.of<TimelineScreenBloc>(context).add(
      TimelineEventMessageToFavorite(
          BlocProvider.of<TimelineScreenBloc>(context)
              .state
              .selectedEventMessage),
    );
  }

  void _deleteEventMessage() {
    BlocProvider.of<TimelineScreenBloc>(context).add(
      TimelineEventMessageDeleted(
          BlocProvider.of<TimelineScreenBloc>(context).state.eventMessageList),
    );
  }
}
