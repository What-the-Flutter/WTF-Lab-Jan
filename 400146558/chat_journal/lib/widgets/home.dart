import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/screens/create_screen/create_page.dart';
import 'package:chat_journal/screens/event_screen/event_page.dart';
import 'package:firebase_database/firebase_database.dart';
import '../theme/theme_constants.dart';
import 'package:chat_journal/screens/home_screen/home_cubit.dart';
import 'package:chat_journal/screens/home_screen/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_helper/icons_helper.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    children: <Widget>[
                      _questionnareBot(),
                      const Divider(),
                      StreamBuilder(
                        stream: state.streamChats,
                        builder: (context, AsyncSnapshot<Event> snap) {
                          if (snap.hasData && !snap.hasError) {
                            DataSnapshot dataValues = snap.data!.snapshot;
                            Map<dynamic, dynamic>? values = dataValues.value;
                            if (values != null) {
                              BlocProvider.of<HomeCubit>(context)
                                  .updateChatsList(values);
                            }
                            return _chatsList(state);
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final newChat = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddChat(
                            editingChat: null,
                          )));
              if (newChat is Chat && mounted) {
                BlocProvider.of<HomeCubit>(context).addChat(newChat);
              }
            },
            child: const Icon(Icons.add),
            backgroundColor: floatingButtonColor,
          ),
        );
      },
    );
  }

  Expanded _chatsList(HomeState state) {
    return Expanded(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: state.chatsList.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemBuilder: (BuildContext context, int index) {
          return _chatCard(index, state.chatsList[index], state);
        },
      ),
    );
  }

  Material _chatCard(int index, Chat chat, HomeState state) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 30.0,
              child: Icon(
                getIconUsingPrefix(name: chat.chatIconTitle!),
                color: Colors.white,
                size: 30.0,
              ),
            ),
            if (chat.isPinned == true) ...[
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.push_pin_rounded,
                    size: 20.0,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ],
        ),
        title: Text(
          chat.title,
          style:
              Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 20.0),
        ),
        subtitle: Text(
          chat.lastMessage!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Dancing',
            fontSize: 25.0,
            color: Colors.blueGrey,
          ),
        ),
        trailing: Text(
          chat.lastMessageTime == null ? '' : chat.lastMessageTime!.fromNow(),
          style:
              Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0),
        ),
        hoverColor: Colors.lightBlueAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetailPage(
                      currentChat: chat,
                      chatIndex: index,
                    )),
          );
        },
        onLongPress: () {
          _functionsWithChat(index, chat);
        },
      ),
    );
  }

  GestureDetector _questionnareBot() {
    return GestureDetector(
      onTap: () => {},
      child: Card(
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: const AssetImage('assets/icons/chatbot.png'),
                backgroundColor: Theme.of(context).cardColor,
              ),
              const SizedBox(
                width: 20.0,
              ),
              Text(
                'Questionnare Bot',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _agreeToDelete(int index, Chat chat) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delete Page?',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Flexible(
                child: Text(
                  'Are you sure you want to delete this page? Entries of this page will be accessable in the timeline',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: () {
                  _deleteChat(chat);
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 30.0,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Delete',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.cancel,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pinChat(Chat chat) {
    BlocProvider.of<HomeCubit>(context).pinChat(chat);
  }

  void _deleteChat(Chat chat) {
    BlocProvider.of<HomeCubit>(context).deleteChat(chat);
  }

  void _functionsWithChat(int index, Chat chat) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.push_pin,
                  color: Colors.lightGreen,
                ),
                title: Text(
                  'Pin/Unpin',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () {
                  _pinChat(chat);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                title: Text(
                  'Edit',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () async {
                  final editChat = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddChat(
                                editingChat: chat,
                              )));
                  if (editChat is Chat && mounted) {
                    BlocProvider.of<HomeCubit>(context).editChat(chat);
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _agreeToDelete(index, chat);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.info,
                  color: Colors.green,
                ),
                title: Text(
                  'Info',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => _moreInfo(chat),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  AlertDialog _moreInfo(Chat chat) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      content: SizedBox(
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 30.0,
                  child: Icon(
                    getIconUsingPrefix(name: chat.chatIconTitle!),
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  chat.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 20.0),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
              'Created',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 14.0),
            ),
            Text(
              chat.time!.yMMMMd,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 14.0),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Last event',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 14.0),
            ),
            Text(
              chat.lastMessageTime == null ? '' : chat.lastMessageTime!.yMMMMd,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 14.0),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
