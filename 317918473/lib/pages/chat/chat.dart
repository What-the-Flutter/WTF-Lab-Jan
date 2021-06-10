import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../models/message.dart';
import '../home/home_cubit.dart';
import 'chat_cubit.dart';

class Chat extends StatefulWidget {
  Chat({Key? key, required this.category}) : super(key: key);
  final Category category;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      buildWhen: (state, oldState) => state is! ChatNotifierOnSuccess,
      listener: (context, state) {
        if (state is ChatNotifierOnSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.notifyMessage),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: state is ChatOnChoose
              ? _appBarcurrentMessage(context, state)
              : _defaultAppBar(state),
          body: !_focus.hasFocus
              ? _body(context, state)
              : GestureDetector(
                  child: _body(context, state),
                  onTap: _focus.unfocus,
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
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
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: sendImageFromGallery,
              ),
              ListTile(
                leading: Icon(
                  Icons.camera,
                  color: Colors.white,
                  size: 28,
                ),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: sendImageFromCamera,
              )
            ],
          ),
        );
      },
    );
  }

  void sendImageFromCamera() async {
    await context.read<ChatCubit>().sendImage(ImageSource.camera);
    Navigator.pop(context);
  }

  void sendImageFromGallery() async {
    await context.read<ChatCubit>().sendImage(ImageSource.camera);
    Navigator.pop(context);
  }

  AppBar _appBarcurrentMessage(BuildContext context, ChatOnChoose state) {
    final list = [
      IconButton(
          onPressed: () => _showDialogForSharing(context),
          icon: Icon(Icons.share)),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => context.read<ChatCubit>().delete(state.currentMessage),
      ),
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => _editMessage(state),
      ),
      IconButton(
        icon: Icon(Icons.copy),
        onPressed: () => _clipBoardSetData(state),
      ),
      IconButton(
        icon: state.currentMessage.isFavorite
            ? Icon(
                Icons.star,
                color: Colors.yellow,
              )
            : Icon(Icons.star_border),
        onPressed: () => context.read<ChatCubit>().favorite(),
      )
    ];

    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () => context.read<ChatCubit>().closePage(),
      ),
      actions: list,
    );
  }

  Column _body(BuildContext context, ChatState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            reverse: true,
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.message.map((message) {
                    return message.isFavorite
                        ? Row(
                            children: [
                              _message(message, state, context),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              )
                            ],
                          )
                        : _message(message, state, context);
                  }).toList(),
                );
              },
            ),
          ),
        ),
        _bottomBar(context, state)
      ],
    );
  }

  Dismissible _message(
      Messages message, ChatState state, BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Icon(Icons.edit),
            Text('Edit'),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete),
            Text('Delete'),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          context.read<ChatCubit>().delete(message);
        } else if (direction == DismissDirection.startToEnd) {
          _editOnDismissMessage(state, message);
        }
      },
      child: GestureDetector(
        child: Message(message),
        onLongPress: () => context.read<ChatCubit>().choose(message),
        onTap: (state is ChatOnChoose)
            ? () => context.read<ChatCubit>().select(message)
            : null,
      ),
    );
  }

  Widget _bottomBar(BuildContext context, ChatState state) {
    return (state is ChatChooseTagProcess)
        ? SizedBox(
            height: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: context.read<ChatCubit>().tagRepository.list.map(
                      (icon) {
                        return IconButton(
                          onPressed: () =>
                              context.read<ChatCubit>().changeTag(icon),
                          icon: Icon(icon),
                        );
                      },
                    ).toList()
                      ..insert(
                        0,
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => context.read<ChatCubit>().closeTag(),
                        ),
                      ),
                  ),
                ),
                _textField(context, state),
              ],
            ),
          )
        : _textField(context, state);
  }

  Form _textField(BuildContext context, ChatState state) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(state.tag),
              onPressed: () => context.read<ChatCubit>().selectTag(),
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
                  border: InputBorder.none,
                ),
              ),
            ),
            _focus.hasFocus
                ? IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.white,
                    onPressed: () => _sendMessage(state),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    onPressed: _showDialog,
                  ),
          ],
        ),
      ),
    );
  }

  AppBar _defaultAppBar(ChatState state) {
    if (state is ChatSearchProgress) {
      return AppBar(
        elevation: 0,
        title: TextFormField(
          textInputAction: TextInputAction.search,
          onChanged: (value) => context.read<ChatCubit>().search(value),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => context.read<ChatCubit>().closePage(),
          ),
        ],
      );
    }
    return AppBar(
      elevation: 0,
      title: Text(widget.category.title),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => context.read<ChatCubit>().search(''),
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {},
        ),
      ],
    );
  }

  void _clipBoardSetData(ChatOnChoose state) =>
      context.read<ChatCubit>().clipBoard(state.currentMessage);

  void _editMessage(ChatOnChoose state) {
    _controller.text = state.currentMessage.message ?? '';
    _focus.nextFocus();
  }

  void _editOnDismissMessage(ChatState state, Messages messages) {
    _controller.text = messages.message ?? '';
    _focus.requestFocus();
  }

  void _sendMessage(ChatState state) {
    if (_formKey.currentState!.validate()) {
      final currentFocus = FocusScope.of(context);
      if (state is ChatOnChoose) {
        context
            .read<ChatCubit>()
            .update(state.currentMessage, _controller.text);
      } else {
        context.read<ChatCubit>().addMessage(_controller.text);
      }
      _controller.clear();
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
  }

  Future<void> _showDialogForSharing(BuildContext parentContext) async {
    final list = context.read<HomeCubit>().repository.list;
    var choosedList = <Category>{};
    await showDialog(
      context: parentContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return list.length != 1
                ? _categoryDialog(
                    list, setState, choosedList, parentContext, context)
                : Dialog(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: Text(
                          'Add additional category',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
          },
        );
      },
    );
  }

  AlertDialog _categoryDialog(
      List<Category> list,
      StateSetter setState,
      Set<Category> choosedList,
      BuildContext parentContext,
      BuildContext context) {
    return AlertDialog(
      title: Text('Share'),
      content: Container(
        height: 200,
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView(
              shrinkWrap: true,
              children: list.map(
                (category) {
                  if (category.id == widget.category.id) {
                    return SizedBox();
                  }
                  return ListTile(
                    leading: Image.asset(category.assetImage),
                    title: Text(category.title),
                    subtitle: Text(category.description),
                    onTap: () {
                      setState(() {
                        if (choosedList.contains(category)) {
                          choosedList.remove(category);
                        } else {
                          choosedList.add(category);
                        }
                      });
                    },
                    trailing: choosedList.contains(category)
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : SizedBox(),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            parentContext.read<ChatCubit>().sharingDone(choosedList);
            Navigator.pop(context);
          },
          child: Text('Done'),
        )
      ],
    );
  }
}

class Message extends StatelessWidget {
  final Messages message;

  const Message(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return message.pathImage == null
        ? Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 2,
              minWidth: 50,
            ),
            decoration: BoxDecoration(
              color: message.pathImage == null
                  ? (message.isSelect ? Colors.deepOrange : Colors.green)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 6, 6, 15),
                  child: Text(
                    message.message ?? '',
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
                ),
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
                      File(message.pathImage!),
                    ),
                  ),
                ),
                message.isSelect
                    ? Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          child: Icon(
                            Icons.done_rounded,
                            size: 20,
                            color: Colors.white,
                            semanticLabel: 'image selected',
                          ),
                        ),
                      )
                    : SizedBox(),
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
          ? 'edited \t ${_correctTime(message.createAt)}'
          : _correctTime(message.createAt),
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _correctTime(DateTime date) {
    final hour = _correct(date.hour);
    final minute = _correct(date.minute);
    return '$hour:$minute';
  }

  String _correct(int value) => value < 10 ? '0$value' : value.toString();
}
