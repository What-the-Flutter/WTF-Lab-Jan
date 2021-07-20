import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/domain.dart';
import 'chat_page_cubit.dart';

class Chat extends StatefulWidget {
  final Category category;
  final List<Category> categoriesList;

  const Chat({Key? key, required this.category, required this.categoriesList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _Chat(categoriesList: categoriesList);
}

class _Chat extends State<Chat> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<Category> categoriesList;

  _Chat({required this.categoriesList});

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatPageCubit>(context).init(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatPageCubit, ChatPageState>(
      builder: (blocContext, state) {
        return Scaffold(
          appBar: state.eventSelected
              ? _selectItemAppBar(
                  state.indexOfSelectedEvent, blocContext, state)
              : _baseAppBar(state),
          body: _chatBody(state, blocContext),
        );
      },
    );
  }

  AppBar _baseAppBar(ChatPageState state) {
    return AppBar(
      title: Center(
        child: Text(widget.category.name),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: SearchEventDelegate(
                events: state.events,
                category: state.category,
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {},
        ),
      ],
    );
  }

  AppBar _selectItemAppBar(
      int index, BuildContext blocContext, ChatPageState state) {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      leading: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () =>
            BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar();
            _editEvent(index, blocContext, state);
          },
        ),
        IconButton(
          icon: Icon(Icons.copy),
          onPressed: () {
            BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar();
            _copyEvent(index, state);
          },
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () =>
              BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar(),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => _deleteAlertDialog(index, blocContext),
          ),
        ),
        IconButton(
          icon: Icon(Icons.reply),
          onPressed: () => showDialog(
            context: context,
            builder: (dialogContext) =>
                _migrateEventDialog(index, blocContext, dialogContext, state),
          ),
        ),
      ],
    );
  }

  Dialog _migrateEventDialog(int eventIndex, BuildContext blocContext,
      BuildContext dialogContext, ChatPageState state) {
    return Dialog(
      elevation: 16,
      child: Container(
        height: 300,
        width: 220,
        child: ListView.separated(
          itemCount: categoriesList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Center(
                child: Text(
                  'Select the page you want to migrate the selected event to!',
                ),
              );
            }
            return ListTile(
              title: Text(categoriesList[index - 1].name),
              leading: Icon(
                initialIcons[categoriesList[index - 1].iconIndex],
              ),
              onTap: () {
                BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar();
                Navigator.pop(dialogContext);
                BlocProvider.of<ChatPageCubit>(blocContext).changeEventCategory(
                  eventIndex,
                  categoriesList[index - 1],
                );
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }

  Widget _chatBody(ChatPageState state, BuildContext blocContext) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _listView(state, blocContext),
        ),
        SizedBox(
          height: 20,
        ),
        state.isSending
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                  ),
                  child: _selectCategoryField(
                      categoriesList, state, blocContext, context),
                ),
              )
            : SizedBox(
                height: 0,
              ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black26,
                ),
              ),
            ),
            child: _messageField(state, blocContext),
          ),
        ),
      ],
    );
  }

  ListView _listView(ChatPageState state, BuildContext blocContext) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: state.events!.length,
      itemBuilder: (context, index) {
        final event = state.events![index];
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              BlocProvider.of<ChatPageCubit>(blocContext).deleteEvent(index);
            } else if (direction == DismissDirection.startToEnd) {
              _editEvent(index, blocContext, state);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            width: 100,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.2,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Card(
                elevation: 3,
                child: ListTile(
                  title: Text(event.text),
                  subtitle: Text(event.dateTime),
                  onLongPress: () {
                    BlocProvider.of<ChatPageCubit>(blocContext)
                        .changeIndexOfSelectedEvent(index);
                    BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Row _messageField(ChatPageState state, BuildContext blocContext) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.camera_alt_outlined),
          iconSize: 30,
          onPressed: () {},
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            controller: _textEditingController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Enter Event',
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        IconButton(
          icon: Icon(Icons.send),
          iconSize: 30,
          onPressed: () {
            if (state.isEditing) {
              BlocProvider.of<ChatPageCubit>(blocContext).editText(
                state.indexOfSelectedEvent,
                _textEditingController.text,
              );
              _textEditingController.clear();
              BlocProvider.of<ChatPageCubit>(blocContext).setEditEvent(false);
            } else {
              BlocProvider.of<ChatPageCubit>(blocContext).addEvent(
                _textEditingController.text,
              );
              _textEditingController.clear();
              BlocProvider.of<ChatPageCubit>(blocContext).setSending(true);
            }
          },
        ),
      ],
    );
  }

  void _editText(int index, BuildContext blocContext) {
    BlocProvider.of<ChatPageCubit>(blocContext)
        .setEventText(index, _textEditingController.text);

    _textEditingController.clear();
    BlocProvider.of<ChatPageCubit>(blocContext).setEditEvent(false);
  }

  void _editEvent(int index, BuildContext blocContext, ChatPageState state) {
    BlocProvider.of<ChatPageCubit>(blocContext).setEditEvent(true);
    _textEditingController.text = state.events![index].text;
    _textEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textEditingController.text.length),
    );
    _focusNode.requestFocus();
  }

  void _copyEvent(int index, ChatPageState state) {
    Clipboard.setData(
      ClipboardData(text: state.events![index].text),
    );
  }

  AlertDialog _deleteAlertDialog(int index, BuildContext blocContext) {
    return AlertDialog(
      title: const Text('Delete event?'),
      elevation: 3,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Yes');
            BlocProvider.of<ChatPageCubit>(blocContext).swapAppBar();
            BlocProvider.of<ChatPageCubit>(blocContext).deleteEvent(index);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}

ListView _selectCategoryField(List<Category> categoriesList,
    ChatPageState state, BuildContext blocContext, BuildContext context) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: categoriesList.length + 1,
    itemBuilder: (context, index) {
      if (index == 0) {
        return Container(
          height: 83,
          width: 80,
          margin: EdgeInsets.all(1),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).focusColor,
          ),
          child: Column(
            children: <Widget>[
              IconButton(
                color: Theme.of(context).accentColor,
                onPressed: () => BlocProvider.of<ChatPageCubit>(blocContext)
                    .setSending(false),
                icon: Icon(Icons.close),
              ),
              Text('Cancel'),
            ],
          ),
        );
      } else {
        final category = categoriesList[index - 1];
        return Container(
          height: 83,
          width: 80,
          margin: EdgeInsets.all(1),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).focusColor,
          ),
          child: Column(
            children: <Widget>[
              IconButton(
                color: Theme.of(context).accentColor,
                onPressed: () {
                  BlocProvider.of<ChatPageCubit>(blocContext)
                      .changeEventCategory(0, category);
                  BlocProvider.of<ChatPageCubit>(blocContext).setSending(false);
                },
                icon: Icon(initialIcons[category.iconIndex]),
              ),
              Text(category.name),
            ],
          ),
        );
      }
    },
  );
}

class SearchEventDelegate extends SearchDelegate {
  final Category? category;
  final List<Event>? events;

  SearchEventDelegate({required this.category, required this.events});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        query = '';
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return events!
            .where(
              (element) => element.text.contains(query),
            )
            .isEmpty
        ? Center(
            child: Text('No matches(((('),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            reverse: true,
            itemCount: events!
                .where(
                  (element) => element.text.contains(query),
                )
                .length,
            itemBuilder: (context, index) {
              final event = events!
                  .where(
                    (element) => element.text.contains(query),
                  )
                  .toList()[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                width: 100,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.2,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(event.text),
                      subtitle: Text(
                        '${event.dateTime}\n${category!.name}',
                      ),
                      isThreeLine: true,
                    ),
                  ),
                ),
              );
            },
          );
  }
}
