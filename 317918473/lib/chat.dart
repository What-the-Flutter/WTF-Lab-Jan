import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'category.dart';
import 'main.dart';

class Chat extends StatefulWidget {
  Chat({Key? key, required this.category}) : super(key: key);
  final Category category;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late ChatMessages _chatMessages;
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  bool onEdit = false;
  final FocusNode _focus = FocusNode();
  int? onChoose;

  @override
  void initState() {
    super.initState();
    _chatMessages = context.read<ChatMessages>();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    debugPrint('Focus: ${_focus.hasFocus}');
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> getImage(ImageSource source) async {
    try {
      final pickedFile = await picker.getImage(source: source);
      if (pickedFile != null) {
        _chatMessages.sendImage(pickedFile.path);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> _showDialog() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: backgroundColor,
              title: Text(
                'Source',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              content: Wrap(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.photo,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: Text(
                      'Gallery',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    onTap: () async {
                      await getImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: Text(
                      'Camera',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    onTap: () async {
                      await getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: onChoose != null
          ? buildAppBarOnChoose(context)
          : buildDefaultAppBar(),
      body: !_focus.hasFocus
          ? buildBody(context)
          : GestureDetector(
              child: buildBody(context),
              onTap: _focus.unfocus,
            ),
    );
  }

  AppBar buildAppBarOnChoose(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          setState(() {
            onChoose = null;
          });
        },
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _chatMessages.delete(onChoose!);
              setState(() {
                onChoose = null;
              });
            }),
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                onEdit = true;
                _controller.text = _chatMessages.messages[onChoose!].message;

                _focus.requestFocus();
              });
            }),
        IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(
                  text: _chatMessages.messages[onChoose!].message));
              setState(() {
                onChoose = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Message saved to clipboard')));
            }),
        IconButton(
            icon: _chatMessages.messages[onChoose!].isFavorite
                ? Icon(
                    Icons.star,
                    color: Colors.yellow,
                  )
                : Icon(Icons.star_border),
            onPressed: () {
              setState(() {
                if (_chatMessages.messages[onChoose!].isFavorite) {
                  _chatMessages.removeFavorite(onChoose!);
                } else {
                  _chatMessages.addFavorite(onChoose!);
                }
              });
            })
      ],
    );
  }

  Column buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            reverse: true,
            child: Consumer<ChatMessages>(
              builder: (context, value, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: value.messages
                      .map((message) => GestureDetector(
                            child: Message(
                              message: message,
                              isChoosed:
                                  onChoose == value.messages.indexOf(message),
                            ),
                            onLongPress: () {
                              setState(() {
                                onChoose = value.messages.indexOf(message);
                              });
                            },
                          ))
                      .toList()),
            ),
          ),
        ),
        buildBottomBar(context)
      ],
    );
  }

  Form buildBottomBar(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            IconButton(
              icon: SvgPicture.asset('assets/img/Soundsmusic.svg'),
              onPressed: () {},
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
                child: TextFormField(
              focusNode: _focus,
              maxLines: null,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.5,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter some text';
                }
                return null;
              },
              onTap: () => setState(_focus.requestFocus),
              controller: _controller,
              decoration: InputDecoration(
                  hintText: 'Write a message...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  border: InputBorder.none),
            )),
            _focus.hasFocus
                ? IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final currentFocus = FocusScope.of(context);
                        if (onEdit) {
                          _chatMessages.update(onChoose!, _controller.text);
                          _chatMessages.messages[onChoose!].edit();
                          onChoose = null;
                        } else {
                          _chatMessages.add(_controller.text);
                        }
                        _controller.clear();

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      }
                    })
                : IconButton(
                    icon: Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    onPressed: _showDialog)
          ],
        ),
      ),
    );
  }

  AppBar buildDefaultAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      title: Text(widget.category.title),
      centerTitle: true,
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
      ],
    );
  }
}

class Message extends StatelessWidget {
  const Message({Key? key, required this.message, this.isChoosed = false})
      : super(
          key: key,
        );
  final Messages message;
  final bool isChoosed;

  @override
  Widget build(BuildContext context) {
    return message.path == null
        ? Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2, minWidth: 50),
            decoration: BoxDecoration(
              color: message.path == null
                  ? (isChoosed ? Colors.deepOrange : Colors.green)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 6, 6, 15),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      wordSpacing: 1,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 2,
                  child: buildTime(),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(message.path!),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black38,
                    ),
                    child: buildTime(),
                  ),
                ),
              ],
            ),
          );
  }

  Text buildTime() {
    return Text(
      message.isEdit
          ? 'edited \t ${setTime(message.date)}'
          : setTime(message.date),
      style: TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  String setTime(DateTime date) {
    final hour = setCorrect(date.hour);
    final minute = setCorrect(date.minute);
    return '$hour:$minute';
  }

  String setCorrect(int value) => value < 10 ? '0$value' : value.toString();
}
