import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../entity/category.dart';
import '../entity/message.dart';
import 'chat_page_cubit.dart';
import 'chat_page_state.dart';

class ChatPage extends StatefulWidget {
  final Category category;

  const ChatPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatPage(category);
}

class _ChatPage extends State<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @required
  _ChatPage(category);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatPageCubit(widget.category),
      child: BlocBuilder<ChatPageCubit, ChatPageState>(
        builder: (blocContext, state) {
          return Scaffold(
            appBar: state.eventSelected
                ? _appBarFromChatPage(state)
                : _appBarWhenSelectedFromChatPage(
                    state,
                    state.indexOfSelectedElement,
                    blocContext,
                  ),
            body: Column(
              children: [
                if (state.category.listMessages.isEmpty) _eventPage(),
                _bodyForInput(state),
                _inputInsideChatPage(state, blocContext),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _appBarFromChatPage(ChatPageState state) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: const BackButton(),
      title: Center(
        child: Text(
          widget.category.title,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.bookmark_border_outlined,
          ),
        ),
      ],
    );
  }

  AppBar _appBarWhenSelectedFromChatPage(ChatPageState state, int index, BuildContext blocContext) {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      leading: IconButton(
        icon: const Icon(
          Icons.clear,
        ),
        onPressed: () => BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar(),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.edit,
          ),
          onPressed: () {
            BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar();
            _editMessage(index, blocContext);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.copy,
          ),
          onPressed: () {
            BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar();
            BlocProvider.of<ChatPageCubit>(blocContext).copyMessages(index);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.bookmark_border,
          ),
          onPressed: () => BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar(),
        ),
        IconButton(
          icon: const Icon(
            Icons.delete,
          ),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => _deleteAlertDialog(index, blocContext),
          ),
        ),
      ],
    );
  }

  Padding _eventPage() {
    return Padding(
      padding: const EdgeInsets.all(
        20,
      ),
      child: Container(
        color: Colors.green[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Center(
                  child: Text(
                    'This is the page where you can'
                    ' track everything about ${widget.category.title} ',
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                '\nAdd your first event to ${widget.category.title} page by entering some text in'
                ' the box bellow and hitting the send button. Long tap the send button to align'
                ' the event in the opposite direction. Tap on bookmark icon on the top right'
                ' corner to show the bookmarked events only.',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyForInput(ChatPageState state) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: state.category.listMessages.length,
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.only(right: 100, top: 5, left: 5),
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Card(
              elevation: 5,
              color: Colors.blueGrey[600],
              child: ListTile(
                title: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    state.category.listMessages[index].text,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd kk:mm').format(state.category.listMessages[index].time),
                  style: TextStyle(
                    color: Colors.blueGrey[200],
                    fontSize: 12,
                  ),
                ),
                onLongPress: () {
                  // state.indexOfSelectedElement = index;
                  BlocProvider.of<ChatPageCubit>(context).changeIndexOfSelectedElement(
                    index,
                  );
                  BlocProvider.of<ChatPageCubit>(context).swapAppBar();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputInsideChatPage(ChatPageState state, BuildContext blocContext) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7.5,
        vertical: 8,
      ),
      decoration: const BoxDecoration(),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.camera_alt_outlined,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 40,
                child: TextField(
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Enter Message',
                    filled: false,
                    hoverColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          40,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    isCollapsed: true,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send,
              ),
              iconSize: 30,
              onPressed: () {
                if (state.isEditing) {
                  BlocProvider.of<ChatPageCubit>(blocContext).editText(
                    state.indexOfSelectedElement,
                    _textEditingController.text,
                  );
                  _textEditingController.clear();
                  BlocProvider.of<ChatPageCubit>(blocContext).setEditMessage(false);
                } else {
                  BlocProvider.of<ChatPageCubit>(blocContext).addMessage(
                    Message(
                      0,
                      DateTime.now(),
                      _textEditingController.text,
                    ),
                  );
                  _textEditingController.clear();
                  BlocProvider.of<ChatPageCubit>(blocContext).setSending(true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(ChatPageState state) {
    state.category.listMessages.insert(
      state.category.listMessages.length,
      Message(
        1,
        DateTime.now(),
        _textEditingController.text,
      ),
    );
    _textEditingController.clear();
  }

  void _editText(int index, BuildContext blocContext) {
    BlocProvider.of<ChatPageCubit>(blocContext).setMessageText(index, _textEditingController.text);

    _textEditingController.clear();
    BlocProvider.of<ChatPageCubit>(blocContext).setEditMessage(false);
  }

  void _editMessage(int index, BuildContext blocContext) {
    BlocProvider.of<ChatPageCubit>(blocContext).setEditMessage(true);
    _textEditingController.text = widget.category.listMessages[index].text;
    _textEditingController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _textEditingController.text.length,
      ),
    );
    _focusNode.requestFocus();
  }

  AlertDialog _deleteAlertDialog(int index, BuildContext blocContext) {
    return AlertDialog(
      title: const Text(
        'Delete this  message?',
      ),
      elevation: 6,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            'Cancel',
          ),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              'Yes',
            );
            BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar();
            BlocProvider.of<ChatPageCubit>(blocContext).deleteMessage(index);
          },
          child: const Text(
            'Yes',
          ),
        ),
      ],
    );
  }
}
