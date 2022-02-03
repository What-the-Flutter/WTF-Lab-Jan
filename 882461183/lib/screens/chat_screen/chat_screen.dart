import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '/data/services/firebase_api.dart';
import '/icons.dart';
import '/models/chat_model.dart';
import '/models/event_model.dart';
import 'chat_screen_cubit.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _searchController = TextEditingController();
  final _eventRef = FirebaseDatabase.instance.ref().child('Events/');

  late final Chat selectedChat =
      ModalRoute.of(context)?.settings.arguments as Chat;

  @override
  void didChangeDependencies() {
    BlocProvider.of<ChatScreenCubit>(context).showEvents(selectedChat.id);
    _eventRef.onValue.listen(
      (event) {
        final eventList = <Event>[];
        final result = event.snapshot.value as Map;
        final list = result.values;
        final finalList = list.toList();
        for (var i = 0; i < finalList.length; i++) {
          final map = Map<String, dynamic>.from(finalList[i]);
          if (map.containsValue(selectedChat.id)) {
            eventList.add(Event.fromJson(map));
          }
        }
        BlocProvider.of<ChatScreenCubit>(context)
            .showEventsFromListen(eventList);
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatScreenCubit, ChatScreenState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _customAppBar(state),
          body: Column(
            children: [
              state.eventList.isEmpty && !state.isShowFavorites
                  ? !state.isSearching
                      ? _emptyListOfMessagess(
                          'Add your first event to "${selectedChat.elementName}"'
                          ' page by entering some text box below and hitting the send button.'
                          'Long tap the send button to align the event in the opposite direction. '
                          'Tap on the bookmark icon on the top right corner to show the bookmarked events only',
                          state,
                        )
                      : _emptyListOfSearchingMessages()
                  : _listOfMessagess(state),
              state.isSearching ? Container() : _bottomRow(state)
            ],
          ),
        );
      },
    );
  }

  Widget _bottomRow(ChatScreenState state) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          state.isCategoriesOpened ? _categoryListView() : Container(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 3),
              Flexible(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    BlocProvider.of<ChatScreenCubit>(context).changeParameters(
                      isCategoriesOpened: !state.isCategoriesOpened,
                    );
                  },
                  icon: Icon(
                    state.categoryIndex == 0
                        ? Icons.bubble_chart
                        : categoriesMap.values.elementAt(state.categoryIndex),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ),
              Flexible(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 9,
                  ),
                  child: _textField(state),
                ),
              ),
              sendIcon(state),
              const SizedBox(width: 7),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryListView() {
    return Container(
      height: 60,
      alignment: Alignment.bottomCenter,
      child: ListView.builder(
        itemCount: categoriesMap.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => BlocProvider.of<ChatScreenCubit>(context).setCategory(
              index,
            ),
            child: Column(
              children: [
                Icon(
                  categoriesMap.values.elementAt(index),
                  size: 35,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                Text(categoriesMap.keys.elementAt(index)),
                const SizedBox(width: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget sendIcon(ChatScreenState state) {
    if (state.isTextFieldEmpty) {
      return Flexible(
        flex: 1,
        child: _CustomIcon(
          !state.isEditing
              ? state.categoryIndex == 0
                  ? Icons.camera_enhance
                  : Icons.send
              : Icons.close,
          !state.isEditing
              ? () {
                  if (state.categoryIndex == 0) {
                    BlocProvider.of<ChatScreenCubit>(context)
                        .addImage(selectedChat.id);
                  } else {
                    BlocProvider.of<ChatScreenCubit>(context)
                        .addEventWithCategory(
                      selectedChat.id,
                      _controller.text,
                    );
                  }
                }
              : () {
                  BlocProvider.of<ChatScreenCubit>(context).changeParameters(
                    isEdit: false,
                    isEmpty: true,
                  );
                  _controller.clear();
                },
          Theme.of(context).colorScheme.secondary,
        ),
      );
    } else {
      return Flexible(
        flex: 1,
        child: _CustomIcon(
          Icons.send,
          !state.isEditing
              ? () {
                  if (state.categoryIndex == 0) {
                    BlocProvider.of<ChatScreenCubit>(context)
                        .addNewEvent(_controller.text, selectedChat.id);
                  } else {
                    BlocProvider.of<ChatScreenCubit>(context)
                        .addEventWithCategory(
                      selectedChat.id,
                      _controller.text,
                    );
                  }
                  _controller.clear();
                }
              : () {
                  BlocProvider.of<ChatScreenCubit>(context)
                      .confirmEditing(_controller.text);
                  _controller.clear();
                },
          Theme.of(context).colorScheme.secondary,
        ),
      );
    }
  }

  Widget _textField(ChatScreenState state) {
    return TextField(
      onChanged: (value) {
        BlocProvider.of<ChatScreenCubit>(context)
            .isTextFiedEmpty(value, selectedChat.id);
      },
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: state.isSearching ? _searchController : _controller,
      cursorColor: Colors.orange[300],
      cursorWidth: 2.5,
      decoration: InputDecoration(
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        hintText: 'Enter Event',
      ),
    );
  }

  Widget _listOfMessagess(ChatScreenState state) {
    if (state.eventList.isEmpty && state.isShowFavorites) {
      return _emptyListOfMessagess(
        'You dont seem to have any bookmarked'
        'envents yet. You can bookmark an event by single tapping the event',
        state,
      );
    }

    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: state.eventList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            confirmDismiss: (direction) async {
              _dismiss(state, direction, index);
            },
            background: Container(
              alignment: Alignment.centerLeft,
              color: Colors.amber,
              padding: const EdgeInsets.only(left: 30),
              child: const Icon(Icons.edit_rounded),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 30),
              child: const Icon(Icons.delete_rounded),
            ),
            key: Key(index.toString()),
            child: GestureDetector(
              onTap: () => BlocProvider.of<ChatScreenCubit>(context).onTap(
                index,
                selectedChat.id,
              ),
              onLongPress: () =>
                  BlocProvider.of<ChatScreenCubit>(context).onLongPress(index),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: _event(state, index),
              ),
            ),
          );
        },
      ),
    );
  }

  void _dismiss(ChatScreenState state, DismissDirection direction, int index) {
    if (state.selectedItemsCount == 0) {
      if (direction == DismissDirection.startToEnd) {}
      if (direction == DismissDirection.endToStart) {
        BlocProvider.of<ChatScreenCubit>(context).deleteFromDismiss(
          index,
          selectedChat.id,
        );
      }
    }
  }

  Widget _event(ChatScreenState state, int index) {
    final unselectedColor = Theme.of(context).colorScheme.primaryVariant;
    final selectedColor = Theme.of(context).colorScheme.secondaryVariant;
    final timeFormat = DateFormat('h:mm a');

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 369),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.only(right: 18, bottom: 6, top: 10, left: 8),
        decoration: BoxDecoration(
          color: state.eventList[index].isSelected
              ? selectedColor
              : unselectedColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            state.eventList[index].categoryIndex == 0
                ? Container(height: 0, width: 0)
                : Icon(categoriesMap.values
                    .elementAt(state.eventList[index].categoryIndex)),
            if (state.eventList[index].imagePath.isNotEmpty)
              _image(index, state)
            else
              Text(
                state.eventList[index].text,
                style: const TextStyle(fontSize: 16),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 3, left: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.eventList[index].isSelected) _isSelectedItem(),
                  Text(
                    timeFormat.format(state.eventList[index].date).toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  if (state.eventList[index].isFavorite) _isFavoriteItem(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _image(int index, ChatScreenState state) {
    return FutureBuilder(
      future: FirebaseApi.getFile('images/${state.eventList[index].imagePath}'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    _FullSizeImage(state.eventList[index].imagePath),
              ),
            ),
            child: Hero(
              tag: 'imageHero',
              child: Image.network(snapshot.data as String),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const CircularProgressIndicator(
            color: Colors.white,
          );
        }
        return Container();
      },
    );
  }

  Widget _emptyListOfSearchingMessages() {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          margin: const EdgeInsets.only(left: 40, right: 40, top: 15),
          color: Theme.of(context).colorScheme.primaryVariant,
          child: Column(
            children: const [
              Icon(Icons.search, size: 35),
              Text('Please enter a search query to begin serching'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyListOfMessagess(String subtext, ChatScreenState state) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                margin: const EdgeInsets.only(left: 40, right: 40, top: 15),
                color: Theme.of(context).colorScheme.primaryVariant,
                child: Column(
                  children: [
                    Text(
                      'This is page where you can track everithing'
                      ' about "${selectedChat.elementName}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      subtext,
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _customAppBar(ChatScreenState state) {
    if (state.isEditing) {
      return PreferredSize(
        child: _editAppBar(),
        preferredSize: const Size(double.infinity, kToolbarHeight),
      );
    }

    return PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: state.selectedItemsCount == 0
          ? !state.isSearching
              ? _unselectedAppBar(state)
              : _searchAppBar(state)
          : _selectedAppBar(state.selectedItemsCount, state),
    );
  }

  PreferredSizeWidget _searchAppBar(ChatScreenState state) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _searchController.clear();
          BlocProvider.of<ChatScreenCubit>(context).changeParameters(
            isSearching: false,
            isEmpty: true,
          );
          BlocProvider.of<ChatScreenCubit>(context).showEvents(selectedChat.id);
        },
      ),
      title: _textField(state),
      actions: [
        !state.isTextFieldEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  BlocProvider.of<ChatScreenCubit>(context)
                      .changeParameters(isEmpty: true, eventList: []);
                },
                icon: const Icon(Icons.close))
            : Container()
      ],
    );
  }

  PreferredSizeWidget _editAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          _controller.clear();
          BlocProvider.of<ChatScreenCubit>(context)
              .changeParameters(isEdit: false);
        },
      ),
      centerTitle: true,
      title: const Text('Editing Mode'),
    );
  }

  PreferredSizeWidget _selectedAppBar(
    int selectedItemsCount,
    ChatScreenState state,
  ) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () =>
            BlocProvider.of<ChatScreenCubit>(context).unselectElements(),
      ),
      title: Text('$selectedItemsCount'),
      actions: [
        IconButton(
          onPressed: () => _choosePage(state),
          icon: const Icon(Icons.reply),
        ),
        selectedItemsCount == 1
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _controller.text = BlocProvider.of<ChatScreenCubit>(context)
                      .editMessageText();
                },
              )
            : Container(),
        IconButton(
          onPressed: () => BlocProvider.of<ChatScreenCubit>(context).copyText(),
          icon: const Icon(Icons.copy),
        ),
        IconButton(
          onPressed: () => BlocProvider.of<ChatScreenCubit>(context)
              .addSelectedToFavorites(),
          icon: const Icon(Icons.bookmark_border),
        ),
        IconButton(
          onPressed: () =>
              BlocProvider.of<ChatScreenCubit>(context).deleteElement(),
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Future _choosePage(ChatScreenState state) {
    var chosenIndex = 0;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Select the page you want to migrate the selected event(s) to!',
          ),
          content: StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 300,
              width: 300,
              child: ListView.builder(
                itemCount: state.chatList.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    title: Text(state.chatList[index].elementName),
                    value: index,
                    groupValue: chosenIndex,
                    onChanged: (index) {
                      setState(() => chosenIndex = index as int);
                    },
                  );
                },
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                BlocProvider.of<ChatScreenCubit>(context)
                    .moveMessageToAnotherChat(chosenIndex);
                Navigator.pop(context);
              },
              child: Text(
                'Ok',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ],
        );
      },
    );
  }

  PreferredSizeWidget _unselectedAppBar(ChatScreenState state) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (state.eventList.isNotEmpty) {
            Navigator.pop(context, state.eventList[0].text);
          } else {
            Navigator.pop(context, 'No events. Click to create one.');
          }
        },
      ),
      title: Text('${selectedChat.elementName}'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            BlocProvider.of<ChatScreenCubit>(context).changeParameters(
              isEmpty: true,
              isSearching: true,
              eventList: [],
            );
          },
        ),
        _favoriteButton(state),
      ],
    );
  }

  IconButton _favoriteButton(ChatScreenState state) {
    return IconButton(
      onPressed: () => BlocProvider.of<ChatScreenCubit>(context)
          .showAllFavorites(selectedChat.id),
      icon: !state.isShowFavorites
          ? const Icon(Icons.bookmark_border)
          : const Icon(
              Icons.bookmark_outlined,
              color: Colors.yellow,
            ),
    );
  }

  Widget _isSelectedItem() {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.secondary,
          size: 15,
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  Widget _isFavoriteItem() {
    return Row(
      children: [
        const Icon(
          Icons.bookmark,
          color: Colors.yellow,
          size: 15,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

class _CustomIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback func;
  final Color color;

  _CustomIcon(this.icon, this.func, this.color);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
      ),
      onPressed: func,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}

class _FullSizeImage extends StatelessWidget {
  final String imagePath;

  _FullSizeImage(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseApi.getFile('images/$imagePath'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Hero(
              tag: 'imageHero',
              child: Image.network(snapshot.data.toString()),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          const CircularProgressIndicator();
        }
        return Container();
      },
    );
  }
}
