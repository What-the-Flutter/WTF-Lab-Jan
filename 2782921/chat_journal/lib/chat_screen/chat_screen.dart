import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/buble.dart';
import '../components/icons.dart';
import '../home_screen/home_cubit.dart';
import '../model/category.dart';
import '../model/message_data.dart';
import '../model/section.dart';
import '../screen_elements/consts.dart';
import '../services/dismissible_widgets.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({required this.indexId});

  final String indexId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late dynamic _selected;
  late int _editNumber;
  late String _messageText;
  final _messageController = TextEditingController();
  final _messageController2 = TextEditingController();
  bool sectionShow = false;

  bool firstMessage = false;
  bool favourite = false;
  @override
  Widget build(BuildContext context) {
    var index = int.parse(widget.indexId);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (_, state) => Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(state.categories[index].title),
          ),
          actions: [
            IconButton(
              onPressed: () {}, //poisk
              icon: const Icon(
                Icons.search,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  favourite = !favourite;
                });
              }, //izbranniy
              icon: favourite
                  ? const Icon(
                      Icons.bookmark,
                    )
                  : const Icon(
                      Icons.bookmark_border_outlined,
                    ),
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context)
                .pushNamedAndRemoveUntil(('/'), (route) => false),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: state.categories[index].message!.isEmpty
                      ? DefaultChat(title: state.categories[index].title)
                      : favourite
                          ? listViewFavourite(state.categories[index].message,
                              index, state.categories)
                          : listViewFavouriteFalse(
                              state.categories[index].message,
                              index,
                              favourite)),
              inputRow(
                messages: state.categories[index].message,
                index: index,
                state: state,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputRow({
    List<MessageData>? messages,
    required int index,
    required HomeState state,
  }) {
    return Column(
      children: [
        Container(
          height: 80,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sections.length,
              itemBuilder: (context, index) {
                return _sectionItem(state, index, context);
              }),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.attach_file,
                color: Colors.indigo,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _messageController,
                onChanged: (value) {
                  _messageText = value;
                  sectionShow = true;
                },
                decoration: kTextFieldDecoration,
                validator: (text) {
                  if (text == '') {
                    return 'Enter a word';
                  } else if (text == null) {
                    return 'Enter a word';
                  } else {
                    print('Error');
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  firstMessage = true;

                  _messageController.clear();

                  context.read<HomeCubit>().addMessage(_messageText, index);
                });
              },
              icon: const Icon(
                Icons.send,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ],
    );
  }

  ListView listViewFavouriteFalse(
      List<MessageData>? list, int indexMessage, bool favourite) {
    return ListView.builder(
      itemCount: list!.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      itemBuilder: (context, index) {
        return Dismissible(
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              final bool res = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                          'Are you sure you want to delete ${list[index]}?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            setState(() {
                              list.removeAt(index);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
              return res;
            } else {
              _editNumber = index;
              _selected = list[index];
              _editText(context, indexMessage);
              list[index] = _selected;
            }
          },
          background: slideRightBackground(),
          secondaryBackground: slideLeftBackground(),
          key: Key('${list[index]}'),
          child: InkWell(
            child: Row(
              children: [
                ChatBubble(
                  index: index,
                  chatMessage: list[index],
                  messageIndex: index,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          context.read<HomeCubit>().messageLike(
                                list[index],
                                index,
                                indexMessage,
                              );
                        });
                      },
                      icon: list[index].liked
                          ? const Icon(Icons.favorite)
                          : const Icon(Icons.favorite_border),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(
                          () {},
                        );
                      },
                      icon: const Icon(
                        Icons.double_arrow_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ListView listViewFavourite(
      List<MessageData>? list, int indexCategory, List<Category> categories) {
    return ListView.builder(
      itemCount: list!.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      itemBuilder: (context, index) {
        return list[index].liked
            ? Dismissible(
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    final bool res = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                                'Are you sure you want to delete ${list[index]}?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  setState(() {
                                    list.removeAt(index);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                    return res;
                  } else {
                    _editNumber = index;
                    _selected = list[index];
                    _editText(context, indexCategory);
                    list[index] = _selected;
                  }
                },
                background: slideRightBackground(),
                secondaryBackground: slideLeftBackground(),
                key: Key('${list[index]}'),
                child: InkWell(
                  child: Row(
                    children: [
                      ChatBubble(
                        index: index,
                        chatMessage: list[index],
                        messageIndex: index,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                context.read<HomeCubit>().messageLike(
                                      list[index],
                                      index,
                                      indexCategory,
                                    );
                              });
                            },
                            icon: list[index].liked
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  _migrateEvent(
                                    context: context,
                                    categories: categories,
                                    indexEvent: index,
                                    indexCategory1: indexCategory,
                                    data: list[index],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.double_arrow_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : Container();
        // : Container();
      },
    );
  }

  void _migrateEvent({
    required BuildContext context,
    required List<Category> categories,
    required int indexCategory1,
    required int indexEvent,
    required MessageData data,
  }) async {
    var indexCategory2 = 0;
    final res = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content:
                const Text('Choose the preferred category to migrate EVENT'),
            actions: <Widget>[
              Container(
                width: 300,
                height: 300,
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('${categories[index].title}'),
                            leading: Radio(
                              value: index,
                              groupValue: indexCategory2,
                              onChanged: (value) {
                                setState(() {
                                  indexCategory2 = value as int;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                          );
                        }),
                    ElevatedButton(
                      child: const Text('Migrate !'),
                      onPressed: () {
                        context.read<HomeCubit>().migrateMessage(
                              data,
                              indexCategory2,
                            );
                        context.read<HomeCubit>().deleteMessage(
                              indexCategory1,
                              indexEvent,
                            );

                        indexCategory2 = 0;

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  void _editText(BuildContext context, indexCategory) async {
    _selected = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Edit the text'),
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messageController2,
                    onChanged: (value) {
                      _messageText = value;
                    },
                    decoration: kTextFieldDecoration,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(
                      () {
                        _messageController2.clear();

                        context.read<HomeCubit>().editEvent(
                            _editNumber, _messageText, indexCategory);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ],
          elevation: 10,
        );
      },
    );

    setState(() {
      _selected = _selected;
    });
  }
}

class DefaultChat extends StatelessWidget {
  const DefaultChat({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 350,
        height: 150,
        color: Colors.indigo,
        child: Center(
          child: Text(
            '${'This is the page where you can track everything about $title'}',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

Widget _sectionItem(HomeState state, int index, BuildContext context) {
  var section = Section(
    title: sections.keys.elementAt(index),
    icon: sections.values.elementAt(index),
  );
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Column(
      children: [
        IconButton(
          icon: Icon(
            section.icon,
            size: 32,
          ),
          onPressed: () {
            context.read<HomeCubit>().setSection(section, index, index);
          },
        ),
        Text(section.title),
      ],
    ),
  );
}
