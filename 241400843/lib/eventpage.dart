import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class EventPageMessages {
  String eventsDescription;

  EventPageMessages({this.eventsDescription});
}

class _EventPageState extends State<EventPage> {
  List<EventPageMessages> events = [];
  TextEditingController inputtextcontroller = TextEditingController();
  //EventPageMessages addnewevent;
  bool onPressed = false;
  int pressIndex = 0;

  void _addToEventList() {
    setState(() {
      events
          .add(EventPageMessages(eventsDescription: inputtextcontroller.text));
      inputtextcontroller.clear();
    });
  }

  ///for input images from galery or camera
  File _imageFile;
  final picker = ImagePicker();

  void _openGallery() async {
    final picture = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (picture != null) {
        _imageFile = File(picture.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _openCamera() async {
    final picture = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (picture != null) {
        _imageFile = File(picture.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _showCameradialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Choose'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: () {
                      _openGallery();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  GestureDetector(
                    child: Text('Camera'),
                    onTap: () {
                      _openCamera();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _edidingEvent(onPressed),
      body: Column(
        children: [
          _eventPageCard,
          //Container(
          // height: 300,
          Expanded(
            child: ListView.builder(
                reverse: false,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: events.length,
                itemBuilder: (_, index) {
                  // return Text('I want to be free');
                  return _newListTile(index);
                  //{  if (index == 0) {
                  //   _eventPageCard;
                  // }
                }),
          ),
          // Container(
          // child: Row(
          //   children: [
          IconButton(
            icon: Icon(
              Icons.bubble_chart,
            ),
            onPressed: () {},
          ),
          TextField(
            controller: inputtextcontroller,
            decoration: InputDecoration(
                hintText: 'Enter event',
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                )),
            // onChanged: (somenewevent) {
            //   setState(() {
            //    somenewevent = inputtextcontroller.text;
            //   });
            // },
          ),
          IconButton(
            icon: Icon(
              Icons.send_sharp,
            ),
            onPressed: () {
              _addToEventList();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.camera_alt,
            ),
            onPressed: () {
              _showCameradialog(context);
            },
          ),
          // ],
          //),
          //),
        ],
      ),
    );
  }

  Widget _newListTile(index) {
    return TextButton(
      child: ListTile(
        title: Text(events[index].eventsDescription),
      ),
      onPressed: () {
        setState(() {
          pressIndex = index;
          onPressed = true;
        });
      },
    );
  }

  Card get _eventPageCard {
    return Card(
        margin: EdgeInsets.all(5.0),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Text(
                'This is page where you can track everything about "Something"',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Text(
                'Text your first event and tap to send it here',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }

  AppBar _edidingEvent(bool flag) {
    if (flag) {
      return AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.clear,
            ),
            onPressed: () {
              setState(() {
                onPressed = false;
              });
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.reply,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.content_copy,
              ),
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: events[pressIndex].eventsDescription));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.bookmark_border,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () {
                // events.remove(addnewevent);
              },
            ),
          ]);
    } else {
      return AppBar(
        title: Text('Someting'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
        ],
      );
    }
  }
}
