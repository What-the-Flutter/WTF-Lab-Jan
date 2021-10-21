import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:intl/intl.dart';

import '../../entity/category.dart';
import '../../entity/message.dart';
import '../../util/domain.dart';
import '../settings/settings_page/settings_cubit.dart';
import 'chat_page_cubit.dart';
import 'chat_page_state.dart';
import 'widgets/search_messages.dart';

class ChatPage extends StatefulWidget {
  final Category category;
  final List<Category> categories;

  ChatPage({
    Key? key,
    required this.category,
    required this.categories,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatPage(
        category,
        categories,
      );
}

class _ChatPage extends State<ChatPage> {
  int _numberOfImageOfScreen = 0;
  bool conditional = false;
  late ChatPageCubit _cubit;
  final Category _category;
  final List<Category> _categories;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @required
  _ChatPage(
    this._category,
    this._categories,
  );

  @override
  void initState() {
    _cubit = ChatPageCubit()..init(_category);
    _textEditingController.addListener(() {
      setState(() {
        conditional = _textEditingController.text.isEmpty ? false : true;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocBuilder<ChatPageCubit, ChatPageState>(
        builder: (blocContext, state) {
          return Scaffold(
            appBar: !state.messageSelected!
                ? _appBarFromChatPage(state)
                : _appBarWhenSelectedFromChatPage(
                    state,
                    state.indexOfSelectedElement!,
                    blocContext,
                  ),
            body: Container(
              decoration: _numberOfImageOfScreen != 0
                  ? _pictureOnScreen(_numberOfImageOfScreen)
                  : const BoxDecoration(),
              child: Column(
                children: [
                  if (state.messageList.isEmpty) _eventPage(),
                  _bodyForInput(state),
                  _inputInsideChatPage(
                    state,
                    blocContext,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _appBarFromChatPage(ChatPageState state) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Center(
        child: Text(
          state.category!.title,
          style: const TextStyle(color: Colors.yellow),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
          ),
          onPressed: () {
            showSearch(
              context: context,
              delegate: SearchMessageDelegate(
                messagesList: state.messageList,
                category: widget.category,
              ),
            );
          },
        ),
        IconButton(
          onPressed: () {
            state.messageList[state.indexOfSelectedElement!].bookmarkIndex != 0
                ? showSearch(
                    context: context,
                    delegate: SearchMessageDelegate(
                      messagesList: state.messageList
                        ..where((element) => state.messageList[1].bookmarkIndex == 1),
                      category: widget.category,
                    ),
                  )
                : showDialog(
                    context: context,
                    builder: (newContext) {
                      return _bookmarkedDialog(context);
                    },
                  );
          },
          icon: const Icon(
            Icons.bookmark_border,
          ),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (newContext) {
                return _dialogOfPictureOnScreen();
              },
            );
          },
          icon: const Icon(
            Icons.image_outlined,
          ),
        ),
      ],
    );
  }

  AppBar _appBarWhenSelectedFromChatPage(
    ChatPageState state,
    int index,
    BuildContext blocContext,
  ) {
    return AppBar(
      backgroundColor: Colors.yellow[800],
      leading: IconButton(
        icon: const Icon(
          Icons.clear,
        ),
        onPressed: () {
          BlocProvider.of<ChatPageCubit>(blocContext).setWritingState(false);
          BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.edit,
          ),
          onPressed: () {
            _cubit.swapAppBar();
            _editMessage(index, blocContext);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.copy,
          ),
          onPressed: () {
            _cubit.swapAppBar();
            _cubit.copyMessage(
              state.messageList[index],
            );
          },
        ),
        IconButton(
          onPressed: () {
            _cubit.updateBookmark(state.indexOfSelectedElement!);
          },
          icon: const Icon(
            Icons.bookmark,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.delete,
          ),
          onPressed: () => showDialog(
            context: context,
            builder: (blocContext) => _deleteAlertDialog(
              index,
              state.messageList[state.indexOfSelectedElement!],
              blocContext,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => showDialog(
            context: context,
            builder: (dialogContext) => _migrateEventDialog(
              index,
              blocContext,
              dialogContext,
              state,
            ),
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
        color: Colors.yellowAccent,
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
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: state.messageList.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: settingsState.bubbleAlignment == Alignment.centerRight
                      ? const EdgeInsets.fromLTRB(5, 5, 170, 5)
                      : const EdgeInsets.fromLTRB(170, 5, 5, 5),
                  alignment: settingsState.bubbleAlignment == Alignment.centerRight
                      ? AlignmentDirectional.topStart
                      : AlignmentDirectional.topEnd,
                  child: Card(
                    elevation: 5,
                    color: Colors.yellow[400],
                    child: state.messageList[index].imagePath?.isEmpty ?? true
                        ? ListTile(
                            title: HashTagText(
                              decoratedStyle: const TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              ),
                              text: state.messageList[index].text,
                              basicStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: settingsState.bubbleAlignment == Alignment.centerRight
                                  ? TextAlign.start
                                  : TextAlign.end,
                            ),
                            subtitle: Text(
                              state.messageList[state.indexOfSelectedElement!].time,
                              style: TextStyle(
                                color: Colors.blueGrey[200],
                                fontSize: 12,
                              ),
                              textAlign: settingsState.bubbleAlignment == Alignment.centerRight
                                  ? TextAlign.start
                                  : TextAlign.end,
                            ),
                            onLongPress: () {
                              _cubit.swapAppBar();
                              BlocProvider.of<ChatPageCubit>(context).changeIndexOfSelectedElement(
                                index,
                              );
                            },
                            onTap: () {
                              BlocProvider.of<ChatPageCubit>(context).changeIndexOfSelectedElement(
                                index,
                              );
                              _cubit.updateBookmark(state.indexOfSelectedElement!);
                            },
                            trailing: state.messageList[index].bookmarkIndex == 1
                                ? const Icon(
                                    Icons.bookmark_border,
                                    size: 30,
                                    color: Colors.white,
                                  )
                                : null,
                          )
                        : Image.file(
                            File(state.messageList[index].imagePath!),
                          ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _inputInsideChatPage(
    ChatPageState state,
    BuildContext blocContext,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7.5,
        vertical: 8,
      ),
      decoration: const BoxDecoration(color: Colors.yellow),
      child: SafeArea(
        child: Row(
          children: [
            !conditional
                ? IconButton(
                    onPressed: () {
                      _cubit.setSendingPhotoState(false);
                      _cubit.getImage();
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                    ),
                  )
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.message,
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 40,
                child: HashTagTextField(
                  decoratedStyle: const TextStyle(fontSize: 20, color: Colors.blue),
                  basicStyle: const TextStyle(fontSize: 20, color: Colors.black),
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
                if (state.isEditing!) {
                  BlocProvider.of<ChatPageCubit>(blocContext).editText(
                    state.messageList[state.indexOfSelectedElement!],
                    _textEditingController.text,
                  );
                  _textEditingController.clear();
                } else {
                  BlocProvider.of<ChatPageCubit>(blocContext)
                      .addMessage(_textEditingController.text);
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
    state.messageList.insert(
      state.messageList.length,
      Message(
        time: DateFormat('yyyy-MM-dd kk:mm').format(
          DateTime.now(),
        ),
        text: _textEditingController.text,
        currentCategoryId: state.category!.categoryId!,
        imagePath: '',
      ),
    );
    _textEditingController.clear();
  }

  Dialog _migrateEventDialog(
    int messageIndex,
    BuildContext blocContext,
    BuildContext dialogContext,
    ChatPageState state,
  ) {
    return Dialog(
      elevation: 16,
      child: Container(
        height: 300,
        width: 220,
        child: ListView.separated(
          itemCount: state.categories!.length + 1,
          itemBuilder: (
            context,
            index,
          ) {
            if (index == 0) {
              return const Center(
                child: Text('select the page you want to forward the message to!'),
              );
            }
            return ListTile(
              title: Text(state.categories![index - 1].title),
              leading: Icon(initialIcons[state.categories![index - 1].iconIndex]),
              onTap: () {
                BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar();
                Navigator.pop(dialogContext);
                BlocProvider.of<ChatPageCubit>(blocContext)
                    .changeMessageCategory(messageIndex, index - 1);
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }

  void _editText(
    Message message,
    BuildContext blocContext,
  ) {
    BlocProvider.of<ChatPageCubit>(blocContext)
        .setMessageText(message, _textEditingController.text);

    _textEditingController.clear();
    BlocProvider.of<ChatPageCubit>(blocContext).setEditState(false);
  }

  void _editMessage(int index, BuildContext blocContext) {
    BlocProvider.of<ChatPageCubit>(blocContext).setEditState(true);
    _textEditingController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _textEditingController.text.length,
      ),
    );
    BlocProvider.of<ChatPageCubit>(blocContext).setEditState(true);
    _focusNode.requestFocus();
  }

  AlertDialog _deleteAlertDialog(
    int index,
    Message message,
    BuildContext blocContext,
  ) {
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
            _cubit.swapAppBar();
            _cubit.deleteMessage(message);
          },
          child: const Text(
            'Yes',
          ),
        ),
      ],
    );
  }

  BoxDecoration _pictureOnScreen(int number) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          'image/oboi$number.jpg',
        ),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _dialogOfPictureOnScreen() {
    return SimpleDialog(
      backgroundColor: Colors.yellow,
      title: const Text(
        'what wallpaper do you prefer?',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      children: [
        SimpleDialogOption(
          child: const Text(
            '1 -  simpson in nirvana',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          onPressed: () {
            setState(() {
              _numberOfImageOfScreen = 1;
            });
          },
        ),
        SimpleDialogOption(
          child: const Text(
            '2 -  return of the turtle',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          onPressed: () {
            setState(() {
              _numberOfImageOfScreen = 2;
            });
          },
        ),
        SimpleDialogOption(
          child: const Text(
            '3 -  astronauts fishing',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          onPressed: () {
            setState(() {
              _numberOfImageOfScreen = 3;
            });
          },
        ),
        SimpleDialogOption(
          child: const Text(
            '4 -  palette!',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          onPressed: () {
            setState(() {
              _numberOfImageOfScreen = 4;
            });
          },
        ),
        SimpleDialogOption(
          child: const Text(
            '5 -  pastila zdorovogo cheloveka',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          onPressed: () {
            setState(() {
              _numberOfImageOfScreen = 5;
            });
          },
        ),
        SimpleDialogOption(
          child: const Text(
            '6 - send in black',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          onPressed: () {
            setState(() {
              _numberOfImageOfScreen = 6;
            });
          },
        ),
      ],
    );
  }

  AlertDialog _bookmarkedDialog(
    BuildContext context,
  ) {
    return AlertDialog(
      backgroundColor: Colors.yellow,
      title: const Text(
        'No bookmarks',
      ),
      elevation: 6,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            'Ok',
          ),
          child: const Text(
            'Ok',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
