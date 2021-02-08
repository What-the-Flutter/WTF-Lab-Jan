import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'custom_dialog.dart';

import 'custom_theme_provider.dart';
import 'event_message.dart';

//temporary checklist for functionality
List<EventMessage> eventMessagesList = [
  EventMessage('Family', DateFormat.yMMMd().add_jm().format(DateTime.now()),
      'Visit relatives', false, false),
  EventMessage('Family', DateFormat.yMMMd().add_jm().format(DateTime.now()),
      'Call grandmothers', true, false),
  EventMessage('Family', DateFormat.yMMMd().add_jm().format(DateTime.now()),
      'Eat everyone in a good mood', false, false),
  EventMessage('Food', DateFormat.yMMMd().add_jm().format(DateTime.now()),
      'dine for 15\$', false, false),
  EventMessage('Food', DateFormat.yMMMd().add_jm().format(DateTime.now()),
      'buy food for dinner', false, false),
  EventMessage('Sport', DateFormat.yMMMd().add_jm().format(DateTime.now()),
      'Football practice at 19 PM', true, false),
  EventMessage('Sport', DateFormat.yMMMd().add_jm().format(DateTime.now()),
      'Swim 4 km', false, false),
  EventMessage('Sport', DateFormat.yMMMd().add_jm().format(DateTime.now()),
      'bicycle 30 km', true, false),
  EventMessage('Travel', DateFormat.yMMMd().add_jm().format(DateTime.now()),
      'Book a hotel in munich', true, false),
];

class EventPage extends StatefulWidget {
  final String title;

  EventPage({Key key, this.title}) : super(key: key);

  @override
  _EventPage createState() => _EventPage();
}

class _EventPage extends State<EventPage> {
  final TextEditingController _textEditingController = TextEditingController();
  EventMessage _bottomSheetEventMessage;
  bool _isWriting = false;
  bool isFavoriteButPressed = false;
  bool isEditing = false;
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appBar,
      body: eventPageBody,
    );
  }

  AppBar get appBar {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.color,
      iconTheme: Theme.of(context).iconTheme,
      title: Container(
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
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.bookmark_border_outlined,
            color: isFavoriteButPressed
                ? Colors.orangeAccent
                : Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            setState(() {
              isFavoriteButPressed = !isFavoriteButPressed;
            });
          },
        ),
      ],
    );
  }

  GestureDetector get eventPageBody {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                child: eventMessageListView,
              ),
            ),
          ),
          eventMessageComposer,
        ],
      ),
    );
  }

  Widget get eventMessageListView {
    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.only(top: 15.0),
      itemCount: eventMessagesList.length,
      itemBuilder: (context, index) {
        final eventMessage = eventMessagesList[index];
        return _eventAndFavoriteMessage(eventMessage);
      },
    );
  }

  Widget _eventAndFavoriteMessage(EventMessage eventMessage) {
    if ((widget.title == eventMessage.nameOfSuggestion &&
            eventMessage.isFavorite &&
            isFavoriteButPressed) ||
        (widget.title == eventMessage.nameOfSuggestion &&
            !isFavoriteButPressed)) {
      return _eventMessage(eventMessage);
    } else {
      return Container();
    }
  }

  Widget _eventMessage(EventMessage eventMessage) {
    return GestureDetector(
      onLongPress: () {
        setState(() => _bottomSheet(context, eventMessage));
      },
      child: Row(
        children: [
          Container(
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
              width: 220,
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
                  eventMessage.isImageMessage
                      ? Image(image: FileImage(eventMessage.image.file))
                      : Text(
                          eventMessage.text,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 17.0,
                          ),
                        ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: eventMessage.isFavorite
                ? Icon(
                    Icons.bookmark,
                    color: Colors.orangeAccent,
                  )
                : Icon(
                    Icons.bookmark_border_outlined,
                    color: Provider.of<ThemeProvider>(context).isDarkMode
                        ? Theme.of(context).accentColor
                        : Colors.black54,
                  ),
            onPressed: () {
              setState(() {
                eventMessage.isFavorite = !eventMessage.isFavorite;
              });
            },
          ),
        ],
      ),
    );
  }

  Container get eventMessageComposer {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: 70.0,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.widgets_outlined),
            iconSize: 25.0,
            onPressed: () {},
          ),
          inputEventMessageTextField,
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

  Expanded get inputEventMessageTextField {
    return Expanded(
      child: TextField(
        controller:
            isEditing ? TextEditingController() : _textEditingController,
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
    eventMessagesList.insert(
      0,
      EventMessage(
        widget.title,
        DateFormat.yMMMd().add_jm().format(DateTime.now()),
        _textEditingController.text,
        false,
        false,
      ),
    );
    _textEditingController.clear();
    isWriting = false;
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
          child: customDialogImageSelect,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return null;
      },
    );
  }

  Widget get customDialogImageSelect {
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
      isEditMessage: false,
    );
  }

  set imageFile(File image) {
    setState(() => _imageFile = image);
  }

  Future _selectedGallery() async {
    final file = await ImagePicker().getImage(source: ImageSource.gallery);
    addImageInEventMessagesList(file);
  }

  Future _selectedCamera() async {
    final file = await ImagePicker().getImage(source: ImageSource.camera);
    addImageInEventMessagesList(file);
  }

  void addImageInEventMessagesList(PickedFile file) {
    if (file != null) {
      imageFile = File(file.path);
      eventMessagesList.insert(
        0,
        EventMessage(
          widget.title,
          DateFormat.yMMMd().add_jm().format(DateTime.now()),
          null,
          false,
          true,
          FileImage(File(_imageFile.path)),
        ),
      );
    }
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
            child: structureBottomSheet(eventMessage),
          );
        });
  }

  Widget structureBottomSheet(EventMessage eventMessage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        listTile(
          context,
          'Forward',
          Icons.arrow_back_outlined,
          _forwardEventMessage,
          eventMessage,
        ),
        eventMessage.isImageMessage
            ? Container()
            : listTile(
                context,
                'Copy',
                Icons.copy,
                _copyEventMessage,
                eventMessage,
              ),
        eventMessage.isImageMessage
            ? Container()
            : listTile(
                context,
                'Edit',
                Icons.edit,
                _editEventMessage,
                eventMessage,
              ),
        listTile(
          context,
          eventMessage.isFavorite
              ? 'Remove from favorites'
              : 'Add to favorites',
          Icons.bookmark_border_outlined,
          _addToFavorites,
          eventMessage,
        ),
        listTile(
          context,
          'Delete',
          Icons.delete,
          _deleteEventMessage,
          eventMessage,
        ),
      ],
    );
  }

  ListTile listTile(BuildContext context, String name, IconData icon,
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

  void _forwardEventMessage() {
    setState(() {
      //will be implemented
      print('forwardEventMessage');
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
    isEditing = true;
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
            isEditMessage: true,
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

  //temporary check of the function
  void _selectedCancel() => print('Cancel');

  void _selectedEdit() {
    setState(() {
      if (_textEditingController.text.isNotEmpty) {
        var index = eventMessagesList.indexOf(_bottomSheetEventMessage);
        eventMessagesList[index].text = _textEditingController.text;
        _textEditingController.clear();
      }
      isEditing = false;
    });
  }

  void _addToFavorites() {
    setState(() {
      _bottomSheetEventMessage.isFavorite =
          !_bottomSheetEventMessage.isFavorite;
    });
  }

  void _deleteEventMessage() {
    setState(() {
      eventMessagesList.remove(_bottomSheetEventMessage);
    });
  }
}
