import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../common_widgets/custom_dialog.dart';
import '../../db_helper/db_helper.dart';
import '../../models/category.dart';
import '../../models/event_message.dart';
import '../../models/font_size_customization.dart';
import '../../models/suggestion.dart';
import '../setting_screen/settings_screen_bloc.dart';
import 'event_screen_bloc.dart';
import 'event_screen_event.dart';
import 'event_screen_state.dart';
import 'forward_dialog.dart';
import 'slidable_swipe_widget.dart';

class EventScreen extends StatefulWidget {
  final String title;
  final Suggestion listViewSuggestion;
  final List<Suggestion> suggestionsList;

  EventScreen(
      {Key key, this.title, this.listViewSuggestion, this.suggestionsList})
      : super(key: key);

  @override
  _EventScreenState createState() =>
      _EventScreenState(listViewSuggestion, suggestionsList);
}

class _EventScreenState extends State<EventScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final Suggestion _listViewSuggestion;
  final SlidableController slidableController = SlidableController();
  final List<Suggestion> _suggestionsList;
  final DBHelper _dbHelper = DBHelper();

  _EventScreenState(this._listViewSuggestion, this._suggestionsList);

  final List<Category> _categoryList = [
    Category(nameOfCategory: 'Journal', imagePath: 'assets/images/journal.png'),
    Category(nameOfCategory: 'Pig', imagePath: 'assets/images/pig.png'),
    Category(
        nameOfCategory: 'Money', imagePath: 'assets/images/money_invest.png'),
    Category(nameOfCategory: 'Tea', imagePath: 'assets/images/tea.png'),
    Category(nameOfCategory: 'Relax', imagePath: 'assets/images/relax.png'),
    Category(nameOfCategory: 'Bar', imagePath: 'assets/images/beer.png'),
    Category(nameOfCategory: 'Bus', imagePath: 'assets/images/bus.png'),
    Category(nameOfCategory: 'Bike', imagePath: 'assets/images/bike.png'),
    Category(nameOfCategory: 'Taxi', imagePath: 'assets/images/taxi1.png'),
  ];

  @override
  void initState() {
    BlocProvider.of<EventScreenBloc>(context).add(
      EventMessageListInit(_listViewSuggestion),
    );
    BlocProvider.of<EventScreenBloc>(context).add(
      UpdateTagList(),
    );
    _dbHelper.initializeDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventScreenBloc, EventScreenState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _appBar,
          body: _eventPageBody,
        );
      },
    );
  }

  AppBar get _appBar {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.color,
      iconTheme: Theme.of(context).iconTheme,
      title: BlocProvider.of<EventScreenBloc>(context)
              .state
              .isSearchIconButtonPressed
          ? TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.white70,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                filled: true,
                fillColor: Colors.white38,
              ),
              onChanged: (value) {
                _filterEventMessageList(value);
              },
            )
          : Container(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: BlocProvider.of<SettingScreenBloc>(context)
                              .state
                              .fontSize ==
                          0
                      ? appBarSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? appBarDefaultFontSize
                          : appBarLargeFontSize,
                ),
              ),
              alignment: Alignment.centerLeft,
            ),
      elevation: 0.0,
      actions: [
        BlocProvider.of<EventScreenBloc>(context)
                .state
                .isSearchIconButtonPressed
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: _closeSearchTextField,
              )
            : IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  BlocProvider.of<EventScreenBloc>(context).add(
                    SearchIconButtonPressed(
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .isSearchIconButtonPressed),
                  );
                },
              ),
        BlocProvider.of<SettingScreenBloc>(context).state.isDateTimeModification
            ? BlocProvider.of<EventScreenBloc>(context)
                    .state
                    .isSearchIconButtonPressed
                ? Container()
                : Row(
                    children: [
                      Text(
                        BlocProvider.of<EventScreenBloc>(context)
                                    .state
                                    .selectedDate ==
                                null
                            ? DateFormat.MEd().format(DateTime.now())
                            : DateFormat.MEd().format(
                                DateTime(
                                  BlocProvider.of<EventScreenBloc>(context)
                                      .state
                                      .selectedDate
                                      .year,
                                  BlocProvider.of<EventScreenBloc>(context)
                                      .state
                                      .selectedDate
                                      .month,
                                  BlocProvider.of<EventScreenBloc>(context)
                                      .state
                                      .selectedDate
                                      .day,
                                ),
                              ),
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: BlocProvider.of<SettingScreenBloc>(context)
                                      .state
                                      .fontSize ==
                                  0
                              ? listTileHeaderSmallFontSize
                              : BlocProvider.of<SettingScreenBloc>(context)
                                          .state
                                          .fontSize ==
                                      1
                                  ? listTileHeaderDefaultFontSize
                                  : listTileHeaderLargeFontSize,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed: () {
                          _pickDate(context);
                        },
                      ),
                    ],
                  )
            : Container(),
        IconButton(
          icon: Icon(
            Icons.bookmark_border_outlined,
            color: BlocProvider.of<EventScreenBloc>(context)
                    .state
                    .isFavoriteButPressed
                ? Colors.orangeAccent
                : Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            BlocProvider.of<EventScreenBloc>(context).add(
              FavoriteButPressed(BlocProvider.of<EventScreenBloc>(context)
                  .state
                  .isFavoriteButPressed),
            );
          },
        ),
      ],
    );
  }

  void _closeSearchTextField() {
    BlocProvider.of<EventScreenBloc>(context).add(
      SearchIconButtonUnpressed(
        BlocProvider.of<EventScreenBloc>(context).state.eventMessageList,
        BlocProvider.of<EventScreenBloc>(context)
            .state
            .isSearchIconButtonPressed,
      ),
    );
  }

  Future _pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: BlocProvider.of<EventScreenBloc>(context).state.selectedDate,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (newDate == null) return;
    BlocProvider.of<EventScreenBloc>(context).add(
      DateSelected(newDate),
    );
    _pickTime(context);
  }

  Future _pickTime(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: BlocProvider.of<EventScreenBloc>(context).state.selectedTime,
    );

    if (newTime == null) return;
    BlocProvider.of<EventScreenBloc>(context).add(
      TimeSelected(newTime),
    );
  }

  void _filterEventMessageList(String value) {
    BlocProvider.of<EventScreenBloc>(context).add(
      EventMessageListFiltered(
          BlocProvider.of<EventScreenBloc>(context).state.eventMessageList,
          value),
    );
    BlocProvider.of<EventScreenBloc>(context)
        .add(EventMessageListFilteredReceived());
  }

  GestureDetector get _eventPageBody {
    return GestureDetector(
      onTap: () => FocusScope.of(context).nextFocus(),
      child: Column(
        children: [
          _tagSelectionTopBar,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                child: _eventMessageListView,
              ),
            ),
          ),
          _categorySelectionBottomBar,
          _eventMessageComposer,
        ],
      ),
    );
  }

  Container get _tagSelectionTopBar {
    return (BlocProvider.of<EventScreenBloc>(context)
                .state
                .tagList
                .isNotEmpty &&
            BlocProvider.of<EventScreenBloc>(context)
                .state
                .isSearchIconButtonPressed)
        ? Container(
            height: 65,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 7.0,
                direction: Axis.horizontal,
                children: BlocProvider.of<EventScreenBloc>(context)
                    .state
                    .tagList
                    .map(
                      (tag) => InputChip(
                        label: Text(tag.tagText),
                        labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        backgroundColor: Theme.of(context).cardTheme.color,
                        onPressed: () => _filterEventMessageList(tag.tagText),
                        onDeleted: () =>
                            BlocProvider.of<EventScreenBloc>(context).add(
                          TagDeleted(
                              tag,
                              BlocProvider.of<EventScreenBloc>(context)
                                  .state
                                  .tagList),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        : Container();
  }

  Container get _categorySelectionBottomBar {
    return BlocProvider.of<EventScreenBloc>(context).state.isCategorySelected
        ? Container(
            height: 75,
            child: GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 1,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              shrinkWrap: true,
              children: _categoryList
                  .map((category) => Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GestureDetector(
                          onTap: () =>
                              BlocProvider.of<EventScreenBloc>(context).add(
                            SelectedCategoryAdded(category),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: category ==
                                          BlocProvider.of<EventScreenBloc>(
                                                  context)
                                              .state
                                              .selectedCategory
                                      ? Colors.limeAccent
                                      : Colors.white,
                                  child: CircleAvatar(
                                    radius: 22,
                                    child: Image.asset(category.imagePath),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  category.nameOfCategory,
                                  style: TextStyle(
                                      color: category ==
                                              BlocProvider.of<EventScreenBloc>(
                                                      context)
                                                  .state
                                                  .selectedCategory
                                          ? Colors.limeAccent
                                          : Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          )
        : Container();
  }

  Widget get _eventMessageListView {
    return BlocProvider.of<EventScreenBloc>(context)
            .state
            .filteredEventMessageList
            .isNotEmpty
        ? ListView.builder(
            reverse: true,
            padding: EdgeInsets.only(top: 15.0),
            itemCount: BlocProvider.of<EventScreenBloc>(context)
                .state
                .filteredEventMessageList
                .length,
            itemBuilder: (context, index) {
              final eventMessage = BlocProvider.of<EventScreenBloc>(context)
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
            BlocProvider.of<EventScreenBloc>(context)
                .state
                .isFavoriteButPressed) ||
        (!BlocProvider.of<EventScreenBloc>(context)
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
    BlocProvider.of<EventScreenBloc>(context).state.selectedEventMessage =
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
            curve: Curves.decelerate,
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
                      eventMessage.time,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
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
                      BlocProvider.of<EventScreenBloc>(context).add(
                        EventMessageToFavorite(eventMessage),
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
                      BlocProvider.of<EventScreenBloc>(context).add(
                        EventMessageToFavorite(eventMessage),
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
                      eventMessage.time,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
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

  Container get _eventMessageComposer {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: 70.0,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        children: <Widget>[
          BlocProvider.of<EventScreenBloc>(context).state.isCategorySelected
              ? IconButton(
                  icon: Icon(Icons.close),
                  iconSize: 25.0,
                  onPressed: _closeSelectionOfCategory,
                )
              : IconButton(
                  icon: Icon(Icons.widgets_outlined),
                  iconSize: 25.0,
                  onPressed: () {
                    BlocProvider.of<EventScreenBloc>(context).add(
                      CategorySelectedModeChanged(
                          BlocProvider.of<EventScreenBloc>(context)
                              .state
                              .isCategorySelected,
                          null),
                    );
                  },
                ),
          _inputEventMessageTextField,
          BlocProvider.of<EventScreenBloc>(context).state.isWriting
              ? IconButton(
                  icon: Icon(Icons.send),
                  iconSize: 25.0,
                  onPressed: _sendIconPressed,
                  tooltip: 'Add message',
                )
              : IconButton(
                  icon: Icon(Icons.photo),
                  iconSize: 25.0,
                  onPressed: _showImageSelectionDialog,
                  tooltip: 'Add image',
                ),
        ],
      ),
    );
  }

  Expanded get _inputEventMessageTextField {
    return Expanded(
      child: TextField(
        controller: BlocProvider.of<EventScreenBloc>(context).state.isEditing
            ? TextEditingController()
            : _textEditingController,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (value) {
          (value.isNotEmpty && value.trim() != '')
              ? BlocProvider.of<EventScreenBloc>(context).add(
                  SendButtonChanged(true),
                )
              : BlocProvider.of<EventScreenBloc>(context).add(
                  SendButtonChanged(false),
                );
        },
        decoration: InputDecoration(
          hintText: 'Enter event',
          hintStyle: TextStyle(
            color: Colors.white70,
          ),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(25.0),
            ),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          filled: true,
          fillColor: Colors.white38,
        ),
      ),
    );
  }

  void _sendIconPressed() {
    BlocProvider.of<EventScreenBloc>(context).add(
      EventMessageAdded(
        EventMessage(
          idOfSuggestion: _listViewSuggestion.id,
          nameOfSuggestion: _listViewSuggestion.nameOfSuggestion,
          time: BlocProvider.of<SettingScreenBloc>(context)
                  .state
                  .isDateTimeModification
              ? DateFormat.yMMMd().add_jm().format(
                    DateTime(
                      BlocProvider.of<EventScreenBloc>(context)
                          .state
                          .selectedDate
                          .year,
                      BlocProvider.of<EventScreenBloc>(context)
                          .state
                          .selectedDate
                          .month,
                      BlocProvider.of<EventScreenBloc>(context)
                          .state
                          .selectedDate
                          .day,
                      BlocProvider.of<EventScreenBloc>(context)
                          .state
                          .selectedTime
                          .hour,
                      BlocProvider.of<EventScreenBloc>(context)
                          .state
                          .selectedTime
                          .minute,
                    ),
                  )
              : DateFormat.yMMMd().add_jm().format(
                    DateTime.now(),
                  ),
          text: _textEditingController.text,
          isFavorite: 0,
          isImageMessage: 0,
          imagePath: 'null',
          categoryImagePath: (BlocProvider.of<EventScreenBloc>(context)
                          .state
                          .selectedCategory ==
                      null ||
                  BlocProvider.of<EventScreenBloc>(context)
                          .state
                          .selectedCategory
                          .nameOfCategory ==
                      'null')
              ? null
              : BlocProvider.of<EventScreenBloc>(context)
                  .state
                  .selectedCategory
                  .imagePath,
          nameOfCategory: (BlocProvider.of<EventScreenBloc>(context)
                          .state
                          .selectedCategory ==
                      null ||
                  BlocProvider.of<EventScreenBloc>(context)
                          .state
                          .selectedCategory
                          .nameOfCategory ==
                      'null')
              ? null
              : BlocProvider.of<EventScreenBloc>(context)
                  .state
                  .selectedCategory
                  .nameOfCategory,
        ),
        BlocProvider.of<EventScreenBloc>(context).state.eventMessageList,
      ),
    );

    BlocProvider.of<EventScreenBloc>(context).add(
      CheckEventMessageForTagAndAdded(_textEditingController.text,
          BlocProvider.of<EventScreenBloc>(context).state.tagList),
    );
    _textEditingController.clear();
    BlocProvider.of<EventScreenBloc>(context).add(
      SendButtonChanged(false),
    );
    BlocProvider.of<EventScreenBloc>(context).state.isCategorySelected
        ? _closeSelectionOfCategory()
        : () {};
    BlocProvider.of<EventScreenBloc>(context).state.isSearchIconButtonPressed
        ? _closeSearchTextField()
        : () {};
  }

  Future<Object> _showImageSelectionDialog() {
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      transitionDuration: Duration(milliseconds: 800),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.decelerate,
            reverseCurve: Curves.easeOutCubic,
          ),
          child: _customDialogImageSelect,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return null;
      },
    );
  }

  Widget get _customDialogImageSelect {
    return CustomDialog.imageSelect(
      title: 'Adding an image',
      content: 'Select an image source',
      firstBtnText: 'Gallery',
      secondBtnText: 'Camera',
      icon: Icon(
        Icons.photo,
        color: Colors.white,
        size: 60,
      ),
      firstBtnFunc: _selectedGallery,
      secondBtnFunc: _selectedCamera,
    );
  }

  Future _selectedGallery() async {
    final file = await ImagePicker().getImage(source: ImageSource.gallery);
    _addImageInEventMessagesList(file);
  }

  Future _selectedCamera() async {
    final file = await ImagePicker().getImage(source: ImageSource.camera);
    _addImageInEventMessagesList(file);
  }

  void _addImageInEventMessagesList(PickedFile file) {
    if (file != null) {
      BlocProvider.of<EventScreenBloc>(context).add(
        EventMessageAdded(
          EventMessage(
            idOfSuggestion: _listViewSuggestion.id,
            nameOfSuggestion: _listViewSuggestion.nameOfSuggestion,
            time: BlocProvider.of<SettingScreenBloc>(context)
                    .state
                    .isDateTimeModification
                ? DateFormat.yMMMd().add_jm().format(
                      DateTime(
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedDate
                            .year,
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedDate
                            .month,
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedDate
                            .day,
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedTime
                            .hour,
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedTime
                            .minute,
                      ),
                    )
                : DateFormat.yMMMd().add_jm().format(
                      DateTime.now(),
                    ),
            text: '',
            isFavorite: 0,
            isImageMessage: 1,
            imagePath: file.path,
            categoryImagePath: (BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedCategory ==
                        null ||
                    BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedCategory
                            .nameOfCategory ==
                        'null')
                ? null
                : BlocProvider.of<EventScreenBloc>(context)
                    .state
                    .selectedCategory
                    .imagePath,
            nameOfCategory: (BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedCategory ==
                        null ||
                    BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedCategory
                            .nameOfCategory ==
                        'null')
                ? null
                : BlocProvider.of<EventScreenBloc>(context)
                    .state
                    .selectedCategory
                    .nameOfCategory,
          ),
          BlocProvider.of<EventScreenBloc>(context).state.eventMessageList,
        ),
      );
    }
    BlocProvider.of<EventScreenBloc>(context).state.isCategorySelected
        ? _closeSelectionOfCategory()
        : () {};
    BlocProvider.of<EventScreenBloc>(context).state.isSearchIconButtonPressed
        ? _closeSearchTextField()
        : () {};
  }

  void _closeSelectionOfCategory() {
    BlocProvider.of<EventScreenBloc>(context).add(
      CategorySelectedModeChanged(
          BlocProvider.of<EventScreenBloc>(context).state.isCategorySelected,
          null),
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
            child: _listTile(
              context,
              'Forward',
              Icons.arrow_back_outlined,
              _forwardEventMessage,
              eventMessage,
            )),
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
    BlocProvider.of<EventScreenBloc>(context)
        .add(EventMessageSelected(eventMessage));
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

  Future<void> _forwardEventMessage() async {
    await showGeneralDialog(
      barrierDismissible: false,
      context: context,
      transitionDuration: Duration(milliseconds: 800),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.decelerate,
            reverseCurve: Curves.easeOutCubic,
          ),
          child: ForwardDialog(
            title: 'Forward',
            firstBtnText: 'Cancel',
            icon: Icon(Icons.arrow_back_outlined),
            selectedFunction: _selectedForward,
            suggestionsList: _suggestionsList,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return null;
      },
    );
  }

  void _selectedForward(Suggestion selectedListViewSuggestion) {
    final selectedEventMessage = BlocProvider.of<EventScreenBloc>(context)
                .state
                .selectedEventMessage
                .isImageMessage ==
            1
        ? EventMessage(
            idOfSuggestion: selectedListViewSuggestion.id,
            nameOfSuggestion: selectedListViewSuggestion.nameOfSuggestion,
            time: BlocProvider.of<SettingScreenBloc>(context)
                    .state
                    .isDateTimeModification
                ? DateFormat.yMMMd().add_jm().format(
                      DateTime(
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedDate
                            .year,
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedDate
                            .month,
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedDate
                            .day,
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedTime
                            .hour,
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedTime
                            .minute,
                      ),
                    )
                : DateFormat.yMMMd().add_jm().format(
                      DateTime.now(),
                    ),
            text: '',
            isFavorite: 0,
            isImageMessage: 1,
            imagePath: BlocProvider.of<EventScreenBloc>(context)
                .state
                .selectedEventMessage
                .imagePath,
            categoryImagePath: BlocProvider.of<EventScreenBloc>(context)
                .state
                .selectedEventMessage
                .categoryImagePath,
            nameOfCategory: BlocProvider.of<EventScreenBloc>(context)
                .state
                .selectedEventMessage
                .nameOfCategory,
          )
        : EventMessage(
            idOfSuggestion: selectedListViewSuggestion.id,
            nameOfSuggestion: selectedListViewSuggestion.nameOfSuggestion,
            time: BlocProvider.of<SettingScreenBloc>(context)
                    .state
                    .isDateTimeModification
                ? DateFormat.yMMMd().add_jm().format(
                      DateTime(
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedDate
                            .year,
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedDate
                            .month,
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedDate
                            .day,
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedTime
                            .hour,
                        BlocProvider.of<EventScreenBloc>(context)
                            .state
                            .selectedTime
                            .minute,
                      ),
                    )
                : DateFormat.yMMMd().add_jm().format(
                      DateTime.now(),
                    ),
            text: BlocProvider.of<EventScreenBloc>(context)
                .state
                .selectedEventMessage
                .text,
            isFavorite: 0,
            isImageMessage: 0,
            imagePath: 'null',
            categoryImagePath: BlocProvider.of<EventScreenBloc>(context)
                .state
                .selectedEventMessage
                .categoryImagePath,
            nameOfCategory: BlocProvider.of<EventScreenBloc>(context)
                .state
                .selectedEventMessage
                .nameOfCategory,
          );
    BlocProvider.of<EventScreenBloc>(context).add(
      EventMessageForwardAdded(
        selectedEventMessage,
      ),
    );
  }

  void _copyEventMessage() {
    Clipboard.setData(
      ClipboardData(
          text: BlocProvider.of<EventScreenBloc>(context)
              .state
              .selectedEventMessage
              .text),
    );
  }

  void _editEventMessage() {
    _showEditEventMessageCustomDialog(
        BlocProvider.of<EventScreenBloc>(context).state.selectedEventMessage);
  }

  Future<Object> _showEditEventMessageCustomDialog(EventMessage eventMessage) {
    BlocProvider.of<EventScreenBloc>(context).add(
      EditingModeChanged(true),
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
            curve: Curves.decelerate,
            reverseCurve: Curves.linearToEaseOut,
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
    BlocProvider.of<EventScreenBloc>(context).add(
      EditingModeChanged(false),
    );
  }

  void _selectedEdit() {
    if (_textEditingController.text.isNotEmpty) {
      BlocProvider.of<EventScreenBloc>(context).add(
        EventMessageEdited(
          _textEditingController.text,
          BlocProvider.of<EventScreenBloc>(context).state.eventMessageList,
        ),
      );
      _textEditingController.clear();
    }
    BlocProvider.of<EventScreenBloc>(context).add(
      EditingModeChanged(false),
    );
  }

  void _addToFavorites() {
    BlocProvider.of<EventScreenBloc>(context).add(
      EventMessageToFavorite(
          BlocProvider.of<EventScreenBloc>(context).state.selectedEventMessage),
    );
  }

  void _deleteEventMessage() {
    BlocProvider.of<EventScreenBloc>(context).add(
      EventMessageDeleted(
        BlocProvider.of<EventScreenBloc>(context).state.eventMessageList,
      ),
    );
  }
}
