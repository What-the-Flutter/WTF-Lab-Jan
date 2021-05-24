import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'category.dart';

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
  final _picker = ImagePicker();
  bool _onEdit = false;
  final FocusNode _focus = FocusNode();
  int? _onChoose;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _onChoose != null ? _appBarOnChoose(context) : _defaultAppBar(),
      body: !_focus.hasFocus
          ? _body(context)
          : GestureDetector(
              child: _body(context),
              onTap: _focus.unfocus,
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
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
      builder: (context) {
        return AlertDialog(
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
                onTap: () => _chooseImageSource(ImageSource.gallery),
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
                onTap: () => _chooseImageSource(ImageSource.camera),
              )
            ],
          ),
        );
      },
    );
  }

  AppBar _appBarOnChoose(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () => setState(() => _onChoose = null),
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _chatMessages.delete(_onChoose!);
              setState(() => _onChoose = null);
            }),
        IconButton(icon: Icon(Icons.edit), onPressed: _editMessage),
        IconButton(icon: Icon(Icons.copy), onPressed: _clipBoardSetData),
        IconButton(
          icon: _chatMessages.messages[_onChoose!].isFavorite
              ? Icon(
                  Icons.star,
                  color: Colors.yellow,
                )
              : Icon(Icons.star_border),
          onPressed: _addOrRemoveFromFavorite,
        )
      ],
    );
  }

  Column _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            reverse: true,
            child: Consumer<ChatMessages>(
              builder: (context, value, child) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: value.messages.map(
                      (message) {
                        return GestureDetector(
                          child: Message(
                            message: message,
                            isChoosed:
                                _onChoose == value.messages.indexOf(message),
                          ),
                          onLongPress: () {
                            setState(
                              () {
                                _onChoose = value.messages.indexOf(message);
                              },
                            );
                          },
                        );
                      },
                    ).toList());
              },
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
              ),
            ),
            _focus.hasFocus
                ? IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.white,
                    onPressed: _sendMessage,
                  )
                : IconButton(
                    icon: Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    onPressed: _showDialog,
                  )
          ],
        ),
      ),
    );
  }

  AppBar _defaultAppBar() {
    return AppBar(
      elevation: 0,
      title: Text(widget.category.title),
      centerTitle: true,
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
      ],
    );
  }

  void _clipBoardSetData() {
    Clipboard.setData(
        ClipboardData(text: _chatMessages.messages[_onChoose!].message));
    setState(() => _onChoose = null);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Message saved to clipboard')));
  }

  Future<void> _chooseImageSource(ImageSource camera) async {
    await _getImage(ImageSource.camera);
    Navigator.pop(context);
  }

  void _editMessage() {
    setState(
      () {
        _onEdit = true;
        _controller.text = _chatMessages.messages[_onChoose!].message;
        _focus.requestFocus();
      },
    );
  }

  void _addOrRemoveFromFavorite() {
    setState(
      () {
        if (_chatMessages.messages[_onChoose!].isFavorite) {
          _chatMessages.removeFavorite(_onChoose!);
        } else {
          _chatMessages.addFavorite(_onChoose!);
        }
      },
    );
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      final currentFocus = FocusScope.of(context);
      if (_onEdit) {
        _chatMessages.update(_onChoose!, _controller.text);
        _chatMessages.messages[_onChoose!].edit();
        _onChoose = null;
      } else {
        _chatMessages.add(_controller.text);
      }
      _controller.clear();

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
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
                  child: _time(),
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
                    child: _time(),
                  ),
                ),
              ],
            ),
          );
  }

  Text _time() {
    return Text(
      message.isEdit
          ? 'edited \t ${_correctTime(message.date)}'
          : _correctTime(message.date),
      style: TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  String _correctTime(DateTime date) {
    final hour = _correct(date.hour);
    final minute = _correct(date.minute);
    return '$hour:$minute';
  }

  String _correct(int value) => value < 10 ? '0$value' : value.toString();
}
