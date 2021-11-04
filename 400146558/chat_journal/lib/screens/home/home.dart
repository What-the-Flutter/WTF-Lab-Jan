import 'package:chat_journal/models/globals.dart';
import 'package:chat_journal/models/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import '../add_chat.dart';
import '../chat_detail_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
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
                  GestureDetector(
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
                              backgroundImage:
                                  const AssetImage('assets/icons/chatbot.png'),
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
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: chats.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Material(
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            leading: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 30.0,
                                  child: Icon(
                                    chats[index].icon,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                                if (chats[index].isPinned == true) ...[
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
                              chats[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontSize: 20.0),
                            ),
                            subtitle: Text(
                              chats[index].messageBase!.isEmpty
                                  ? 'No events. Click to create one'
                                  : chats[index].messageBase!.first.message,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Dancing',
                                fontSize: 25.0,
                                color: Colors.blueGrey,
                              ),
                            ),
                            trailing: Text(
                              chats[index].messageBase!.isEmpty
                                  ? ''
                                  : chats[index]
                                      .messageBase!
                                      .first
                                      .time
                                      .fromNow(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 14.0),
                            ),
                            hoverColor: Colors.lightBlueAccent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatDetailPage(
                                          chatIndex: index,
                                        )),
                              ).then((value) => setState(() {}));
                            },
                            onLongPress: () {
                              _functionsWithChat(index);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddChat(
                      chatIndex: -1,
                    )),
          ).then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
        backgroundColor: floatingButtonColor,
      ),
    );
  }

  void _pinChat(int index) {
    setState(() {
      var _chosenChat = chats.removeAt(index);
      if (_chosenChat.isPinned == false) {
        var _indexLastPinned =
            chats.lastIndexWhere((element) => element.isPinned == true);
        _indexLastPinned == -1
            ? chats.insert(0, _chosenChat)
            : chats.insert(_indexLastPinned + 1, _chosenChat);
        _chosenChat.isPinned = true;
      } else {
        chats.insert(_chosenChat.myIndex, _chosenChat);
        _chosenChat.isPinned = false;
      }
    });
  }

  void _deleteChat(int index) {
    setState(() {
      chats.removeAt(index);
    });
  }

  void _functionsWithChat(int index) {
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
                  _pinChat(index);
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddChat(
                              chatIndex: index,
                            )),
                  ).then((value) {
                    setState(() {});
                    Navigator.pop(context);
                  });
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
                  _deleteChat(index);
                  Navigator.pop(context);
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
                    builder: (context) => AlertDialog(
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
                                    chats[index].icon,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  chats[index].title,
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
                              chats[index].time!.yMMMMd,
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
                              chats[index].messageBase!.isEmpty
                                  ? chats[index].time!.yMMMMd
                                  : chats[index].messageBase!.first.time.yMMMMd,
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
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
