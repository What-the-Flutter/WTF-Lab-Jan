import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../db_helper/db_helper.dart';
import '../models/category.dart';
import '../models/event_message.dart';
import '../models/suggestion.dart';
import '../theme_provider/custom_theme_provider.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/forward_dialog.dart';
import '../widgets/slidable_swipe_widget.dart';

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

  List<EventMessage> _filteredEventMessageList;
  EventMessage _bottomSheetEventMessage;
  File _imageFile;
  Category _selectedCategory;
  bool _isSearchIconButtonPressed = false;
  bool _isWriting = false;
  bool _isFavoriteButPressed = false;
  bool _isEditing = false;
  bool _isCategorySelected = false;

  _EventScreenState(this._listViewSuggestion, this._suggestionsList);

  //a temporary list to check the functionality of
  // adding a message with the selected category
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

  void _updateEventMessageList() {
    var dbEventMessageList = _dbHelper.dbEventMessagesList();
    var eventMessageList = <EventMessage>[];
    dbEventMessageList.then((dbCurrentEventMessageList) {
      setState(() {
        for (var i = 0; i < dbCurrentEventMessageList.length; i++) {
          if (dbCurrentEventMessageList[i].nameOfSuggestion == widget.title) {
            eventMessageList.insert(0, dbCurrentEventMessageList[i]);
          }
        }
        _filteredEventMessageList = eventMessageList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appBar,
      body: _eventPageBody,
    );
  }

  @override
  void initState() {
    setState(() {
      _filteredEventMessageList = _listViewSuggestion.eventMessagesList;
    });
    _dbHelper.initializeDatabase();
    super.initState();
  }

  AppBar get _appBar {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.color,
      iconTheme: Theme.of(context).iconTheme,
      title: _isSearchIconButtonPressed
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
                  color: Provider.of<ThemeProvider>(context).isDarkMode
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor,
                ),
              ),
              alignment: Alignment.centerLeft,
            ),
      elevation: 0.0,
      actions: [
        _isSearchIconButtonPressed
            ? IconButton(
                icon: Icon(Icons.close), onPressed: _closeSearchTextField)
            : IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _isSearchIconButtonPressed = !_isSearchIconButtonPressed;
                  });
                },
              ),
        IconButton(
          icon: Icon(
            Icons.bookmark_border_outlined,
            color: _isFavoriteButPressed
                ? Colors.orangeAccent
                : Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            setState(() {
              _isFavoriteButPressed = !_isFavoriteButPressed;
            });
          },
        ),
      ],
    );
  }

  void _closeSearchTextField() {
    setState(() {
      _filteredEventMessageList = _listViewSuggestion.eventMessagesList;
      _isSearchIconButtonPressed = !_isSearchIconButtonPressed;
    });
  }

  void _filterEventMessageList(value) {
    setState(() {
      _filteredEventMessageList = _listViewSuggestion.eventMessagesList
          .where((suggestion) => suggestion.isImageMessage == 1
              ? 'Image'.toLowerCase().contains(value.toLowerCase())
              : suggestion.text.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  GestureDetector get _eventPageBody {
    return GestureDetector(
      onTap: () => FocusScope.of(context).nextFocus(),
      child: Column(
        children: [
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
          _isCategorySelected ? _categorySelectionBottomBar : Container(),
          _eventMessageComposer,
        ],
      ),
    );
  }

  Container get _categorySelectionBottomBar {
    return _isCategorySelected
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
                          onTap: () => setState(() {
                            _selectedCategory = category;
                          }),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: category == _selectedCategory
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
                                      color: category == _selectedCategory
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
    return _filteredEventMessageList.isNotEmpty
        ? ListView.builder(
            reverse: true,
            padding: EdgeInsets.only(top: 15.0),
            itemCount: _filteredEventMessageList.length,
            itemBuilder: (context, index) {
              final eventMessage = _filteredEventMessageList[index];
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
    if ((eventMessage.isFavorite == 1 && _isFavoriteButPressed) ||
        (!_isFavoriteButPressed)) {
      return SwipeWidget(
        child: _eventMessage(eventMessage, false),
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
    setState(() {
      _bottomSheetEventMessage = eventMessage;
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
    });
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
            curve: Curves.elasticOut,
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

  Widget _eventMessage(EventMessage eventMessage, bool isSelected) {
    return GestureDetector(
      onLongPress: () {
        isSelected
            ? () {}
            : setState(() => _bottomSheet(context, eventMessage));
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
                            color:
                                Provider.of<ThemeProvider>(context).isDarkMode
                                    ? Theme.of(context).accentColor
                                    : Colors.black54,
                          ),
                    onPressed: () {
                      setState(() {
                        eventMessage.isFavorite =
                            (eventMessage.isFavorite == 1) ? 0 : 1;
                        _dbHelper.updateEventMessage(eventMessage);
                        _updateEventMessageList();
                      });
                    },
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
          _isCategorySelected
              ? IconButton(
                  icon: Icon(Icons.close),
                  iconSize: 25.0,
                  onPressed: _closeSelectionOfCategory,
                )
              : IconButton(
                  icon: Icon(Icons.widgets_outlined),
                  iconSize: 25.0,
                  onPressed: () {
                    setState(() {
                      _isCategorySelected = !_isCategorySelected;
                    });
                  },
                ),
          _inputEventMessageTextField,
          _isWriting
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

  void _closeSelectionOfCategory() {
    setState(() {
      _isCategorySelected = !_isCategorySelected;
      _selectedCategory = null;
    });
  }

  Expanded get _inputEventMessageTextField {
    return Expanded(
      child: TextField(
        controller:
            _isEditing ? TextEditingController() : _textEditingController,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (value) {
          (value.isNotEmpty && value.trim() != '')
              ? isWriting = true
              : isWriting = false;
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
    _isSearchIconButtonPressed ? _closeSearchTextField() : () {};
    var eventMessage = EventMessage(
      nameOfSuggestion: widget.title,
      time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
      text: _textEditingController.text,
      isFavorite: 0,
      isImageMessage: 0,
      imagePath: 'null',
      categoryImagePath:
          _selectedCategory == null ? null : _selectedCategory.imagePath,
      nameOfCategory:
          _selectedCategory == null ? null : _selectedCategory.nameOfCategory,
    );
    _dbHelper.insertEventMessage(eventMessage);
    _updateEventMessageList();
    _textEditingController.clear();
    isWriting = false;
    _isCategorySelected ? _closeSelectionOfCategory() : () {};
  }

  set isWriting(bool isWriting) {
    setState(() {
      _isWriting = isWriting;
    });
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
            curve: Curves.elasticOut,
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

  set imageFile(File image) {
    setState(() => _imageFile = image);
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
    _isSearchIconButtonPressed ? _closeSearchTextField() : () {};
    if (file != null) {
      imageFile = File(file.path);
      _dbHelper.insertEventMessage(EventMessage(
        nameOfSuggestion: widget.title,
        time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
        text: '',
        isFavorite: 0,
        isImageMessage: 1,
        imagePath: _imageFile.path,
        categoryImagePath:
            _selectedCategory == null ? null : _selectedCategory.imagePath,
        nameOfCategory:
            _selectedCategory == null ? null : _selectedCategory.nameOfCategory,
      ));
      _updateEventMessageList();
    }
    _isCategorySelected ? _closeSelectionOfCategory() : () {};
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
              : _eventMessage(eventMessage, true),
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
    _bottomSheetEventMessage = eventMessage;
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        name,
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
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
            curve: Curves.elasticOut,
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
    setState(() {});
  }

  void _selectedForward(Suggestion selectedListViewSuggestion) {
    setState(() {
      var selectedEventMessage = _bottomSheetEventMessage.isImageMessage == 1
          ? EventMessage(
              nameOfSuggestion: selectedListViewSuggestion.nameOfSuggestion,
              time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
              text: '',
              isFavorite: 0,
              isImageMessage: 1,
              imagePath: _bottomSheetEventMessage.imagePath,
              categoryImagePath: _bottomSheetEventMessage.categoryImagePath,
              nameOfCategory: _bottomSheetEventMessage.nameOfCategory,
            )
          : EventMessage(
              nameOfSuggestion: selectedListViewSuggestion.nameOfSuggestion,
              time: DateFormat.yMMMd().add_jm().format(DateTime.now()),
              text: _bottomSheetEventMessage.text,
              isFavorite: 0,
              isImageMessage: 0,
              imagePath: 'null',
              categoryImagePath: _bottomSheetEventMessage.categoryImagePath,
              nameOfCategory: _bottomSheetEventMessage.nameOfCategory,
            );
      _dbHelper.insertEventMessage(selectedEventMessage);
      _updateEventMessageList();
    });
  }

  void _copyEventMessage() {
    setState(() {
      Clipboard.setData(ClipboardData(text: _bottomSheetEventMessage.text));
    });
  }

  void _editEventMessage() {
    setState(() {
      _showEditEventMessageCustomDialog(_bottomSheetEventMessage);
    });
  }

  Future<Object> _showEditEventMessageCustomDialog(EventMessage eventMessage) {
    _isEditing = true;
    _textEditingController.text = eventMessage.text;
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      transitionDuration: Duration(milliseconds: 800),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
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
    setState(() {
      _textEditingController.clear();
      _isEditing = false;
    });
    print('Cancel');
  }

  void _selectedEdit() {
    setState(() {
      if (_textEditingController.text.isNotEmpty) {
        _bottomSheetEventMessage.text = _textEditingController.text;
        _dbHelper.updateEventMessage(_bottomSheetEventMessage);
        _updateEventMessageList();
        _textEditingController.clear();
      }
      _isEditing = false;
    });
  }

  void _addToFavorites() {
    setState(() {
      _bottomSheetEventMessage.isFavorite =
          (_bottomSheetEventMessage.isFavorite == 1) ? 0 : 1;
      _dbHelper.updateEventMessage(_bottomSheetEventMessage);
      _updateEventMessageList();
    });
  }

  void _deleteEventMessage() {
    setState(() {
      _dbHelper.deleteEventMessage(_bottomSheetEventMessage);
      _listViewSuggestion.eventMessagesList.remove(_bottomSheetEventMessage);
      _updateEventMessageList();
    });
  }
}
