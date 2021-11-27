import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/screens/create_screen/create_state.dart';
import 'package:chat_journal/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_helper/icons_helper.dart';
import 'package:jiffy/jiffy.dart';

import 'create_cubit.dart';

class AddChat extends StatefulWidget {
  const AddChat({Key? key, required this.editingChat}) : super(key: key);
  final Chat? editingChat;

  @override
  _AddChatState createState() => _AddChatState();
}

class _AddChatState extends State<AddChat> {
  final TextEditingController _textController = TextEditingController();
  Chat? editingChat;
  bool _isWriting = false;

  @override
  void initState() {
    if (widget.editingChat != null) {
      _textController.text = widget.editingChat!.title;
    }
    editingChat = widget.editingChat;
    BlocProvider.of<CreatePageCubit>(context).init(editingChat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePageCubit, CreatePageState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.only(
                left: 30.0, right: 30.0, top: 50.0, bottom: 30.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    widget.editingChat == null
                        ? 'Create a new Page'
                        : 'Edit Page',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text('Name of the page',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: floatingButtonColor)),
                        ),
                        TextField(
                          maxLines: 1,
                          controller: _textController,
                          enableSuggestions: true,
                          autofocus: true,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).cardColor,
                            filled: true,
                            border: InputBorder.none,
                          ),
                          cursorColor: floatingButtonColor,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 14.0),
                          onChanged: (text) {
                            setState(() {
                              _textController.text.isNotEmpty
                                  ? _isWriting = true
                                  : _isWriting = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  _iconsGrid(state),
                ],
              ),
            ),
          ),
          floatingActionButton: _isWriting
              ? FloatingActionButton(
                  onPressed: () {
                    editingChat == null ? _addChat(state) : _editChat(state);
                  },
                  child: const Icon(Icons.check),
                  backgroundColor: floatingButtonColor,
                )
              : FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                  backgroundColor: floatingButtonColor,
                ),
        );
      },
    );
  }

  Expanded _iconsGrid(CreatePageState state) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(20.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
        ),
        itemCount: state.iconsList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _check(state.iconsList[index]),
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 30.0,
                  child: Icon(
                    getIconUsingPrefix(name: state.iconsList[index]),
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                if (state.iconsList[index] == state.selectedChatIcon) ...[
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.check,
                            size: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _check(String chatIcon) {
    BlocProvider.of<CreatePageCubit>(context).check(chatIcon);
  }

  void _addChat(CreatePageState state) {
    Chat newChat = Chat(
      isPinned: false,
      title: _textController.text,
      time: Jiffy(DateTime.now()),
      id: '',
      chatIconTitle: state.selectedChatIcon,
      lastMessage: '',
      lastMessageTime: null,
    );
    Navigator.of(context).pop(newChat);
  }

  void _editChat(CreatePageState state) {
    editingChat!.title = _textController.text;
    editingChat!.chatIconTitle = state.selectedChatIcon;
    Navigator.of(context).pop(editingChat);
  }
}
