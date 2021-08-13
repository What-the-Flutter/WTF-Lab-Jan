import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../models/event.dart';

class EventPage extends StatefulWidget {
  final String title;
  final List<Event> events = [];

  EventPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(title: title);
}

class _EventPageState extends State<EventPage> {
  final String title;
  final _controller = TextEditingController();
  bool _isEditingText = false;
  File? _imageFile;

  _EventPageState({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, title),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: defaultPadding / 2),
              reverse: true,
              itemCount: widget.events.length,
              itemBuilder: (context, index) {
                return _eventMessage(widget.events[index]);
              },
            ),
          ),
          _bottomInput(),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      elevation: 15,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 28,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      shadowColor: primaryColor,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          letterSpacing: 2,
          fontSize: 26,
        ),
      ),
    );
  }

  Widget _bottomInput() {
    var insert = true;
    return Container(
      margin: const EdgeInsets.only(
        bottom: defaultPadding,
        left: defaultPadding / 2,
        right: defaultPadding / 2,
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              _getFromGallery();
              _imageFile != null
                  ? widget.events.insert(
                      0,
                      Event(
                        text: '',
                        isBookmarked: false,
                        isSelected: false,
                        isEdit: false,
                        image: _imageFile,
                      ),
                    )
                  : _imageFile = null;
              _imageFile = null;
            },
            icon: const Icon(
              Icons.camera_enhance_rounded,
              color: secondColor,
              size: 32,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: Colors.white,
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
            width: 312,
            child: TextField(
              controller: _controller,
              onChanged: (value) {},
              decoration: const InputDecoration(
                hintText: 'Enter Event',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () => {
              if (insert && !_isEditingText)
                {
                  widget.events.insert(
                    0,
                    Event(
                      text: _controller.text,
                      isEdit: false,
                      image: null,
                      isSelected: false,
                      isBookmarked: false,
                    ),
                  ),
                },
              for (var event in widget.events)
                {
                  if (event.isEdit)
                    {
                      event.text = _controller.text,
                      event.isEdit = false,
                      insert = false,
                      _isEditingText = false,
                    },
                },
              setState(() {}),
              _controller.text = ''
            },
            icon: const Icon(
              Icons.send_rounded,
              color: secondColor,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventMessage(Event event) {
    return GestureDetector(
      onLongPress: () {
        event.isSelected = !event.isSelected;
        setState(() {});
      },
      onTap: () => showModalBottomSheet(
          context: context,
          builder: (context) {
            return _modalBottomSheet(event, context);
          }),
      child: Container(
        margin: const EdgeInsets.only(
          left: defaultPadding / 2,
          right: defaultPadding * 10,
          top: defaultPadding / 2,
          bottom: defaultPadding / 2,
        ),
        padding: const EdgeInsets.all(defaultPadding / 2),
        decoration: BoxDecoration(
          color:
              event.isSelected ? primaryColor.withOpacity(0.2) : Colors.white,
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
          children: event.image != null
              ? <Widget>[
                  Flexible(
                    child: Image.file(event.image!),
                  ),
                ]
              : <Widget>[
                  Text(
                    event.text,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Row(
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
                                  setState(() {});
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
                  ),
                ],
        ),
      ),
    );
  }

  Wrap _modalBottomSheet(Event event, BuildContext context) {
    return Wrap(
            children: [
              ListTile(
                leading:
                    const Icon(Icons.bookmark_rounded, color: secondColor),
                title: const Text('Bookmark'),
                onTap: () {
                  event.isBookmarked = true;
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_rounded, color: secondColor),
                title: const Text('Copy'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: event.text));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_rounded, color: secondColor),
                title: const Text('Edit'),
                onTap: () {
                  _isEditingText = true;
                  _controller.text = event.text;
                  event.isEdit = true;
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_rounded, color: secondColor),
                title: const Text('Delete'),
                onTap: () {
                  widget.events.remove(event);
                  setState(() {});
                  Navigator.pop(context);
                },
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
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
}
