import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:lottie/lottie.dart';

import '/data/services/firebase_api.dart';
import '/icons.dart';
import '/models/chat_model.dart';
import '../settings/settings_cubit.dart';
import 'event_screen_cubit.dart';

class EventScreen extends StatefulWidget {
  EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _searchController = TextEditingController();
  late final AnimationController _animController;

  late final Chat selectedChat =
      ModalRoute.of(context)?.settings.arguments as Chat;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _animController.reset();
        }
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<EventScreenCubit>(context).initCubit(selectedChat.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventScreenCubit, EventScreenState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _customAppBar(state),
          body: BlocProvider.of<SettingsCubit>(context)
                      .state
                      .backgroundImagePath ==
                  ''
              ? _body(state)
              : _backgroundImageBody(state),
        );
      },
    );
  }

  Widget _body(EventScreenState state) {
    if (state.isSearching) {
      return Column(
        children: [
          state.eventList.isEmpty
              ? _emptyListOfSearchingMessages()
              : _listOfMessagess(state),
        ],
      );
    }

    return Column(
      children: [
        state.eventList.isEmpty && !state.isShowFavorites
            ? _emptyListOfMessagess(
                'Add your first event to "${selectedChat.elementName}"'
                ' page by entering some text box below and hitting the send button.'
                'Long tap the send button to align the event in the opposite direction. '
                'Tap on the bookmark icon on the top right corner to show the bookmarked events only',
                state,
              )
            : _listOfMessagess(state),
        _bottomRow(state),
      ],
    );
  }

  Widget _backgroundImageBody(EventScreenState state) {
    return Stack(
      children: [
        Image.file(
          File(
            BlocProvider.of<SettingsCubit>(context).state.backgroundImagePath,
          ),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        _body(state),
      ],
    );
  }

  Widget _bottomRow(EventScreenState state) {
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
                    BlocProvider.of<EventScreenCubit>(context).changeParameters(
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
              Flexible(
                flex: 1,
                child: !state.isTextFieldEmpty
                    ? sendIcon(state)
                    : closeIcon(state),
              ),
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
            onTap: () => BlocProvider.of<EventScreenCubit>(context).setCategory(
              index,
            ),
            child: Column(
              children: [
                Icon(
                  categoriesMap.values.elementAt(index),
                  size: 35,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                Text(
                  categoriesMap.keys.elementAt(index),
                  style: TextStyle(
                      fontSize: BlocProvider.of<SettingsCubit>(context)
                          .state
                          .fontSize),
                ),
                const SizedBox(width: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget closeIcon(EventScreenState state) {
    return _CustomIcon(
      !state.isEditing
          ? state.categoryIndex == 0
              ? Icons.camera_enhance
              : Icons.send
          : Icons.close,
      !state.isEditing
          ? () => addEventWithCategoryOrImage(state)
          : () {
              BlocProvider.of<EventScreenCubit>(context).changeParameters(
                isEdit: false,
                isEmpty: true,
              );
              _controller.clear();
            },
      Theme.of(context).colorScheme.secondary,
    );
  }

  void addEventWithCategoryOrImage(EventScreenState state) {
    if (state.categoryIndex == 0) {
      BlocProvider.of<EventScreenCubit>(context)
          .addImage(selectedChat.id, selectedChat.elementName);
    } else {
      BlocProvider.of<EventScreenCubit>(context).addEventWithCategory(
        selectedChat.id,
        _controller.text,
        selectedChat.elementName,
      );
    }
  }

  Widget sendIcon(EventScreenState state) {
    return _CustomIcon(
      Icons.send,
      !state.isEditing
          ? () => addNewEvent(state)
          : () {
              BlocProvider.of<EventScreenCubit>(context)
                  .confirmEditing(_controller.text);
              _controller.clear();
            },
      Theme.of(context).colorScheme.secondary,
    );
  }

  void addNewEvent(EventScreenState state) {
    if (state.categoryIndex == 0) {
      BlocProvider.of<EventScreenCubit>(context).addNewEvent(
        _controller.text,
        selectedChat.id,
        selectedChat.elementName,
      );
    } else {
      BlocProvider.of<EventScreenCubit>(context).addEventWithCategory(
        selectedChat.id,
        _controller.text,
        selectedChat.elementName,
      );
    }
    _controller.clear();
  }

  Widget _textField(EventScreenState state) {
    return TextField(
      onChanged: (value) {
        BlocProvider.of<EventScreenCubit>(context)
            .isTextFieldEmpty(value, selectedChat.id);
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

  Widget _listOfMessagess(EventScreenState state) {
    if (state.eventList.isEmpty && state.isShowFavorites) {
      return _emptyListOfMessagess(
        'You dont seem to have any bookmarked'
        'envents yet. You can bookmark an event by single tapping the event',
        state,
      );
    }
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: state.eventList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              if (index == state.eventList.length - 1 ||
                  dateFormat.format(state.eventList[index].date) !=
                      dateFormat.format(state.eventList[index + 1].date))
                _eventDate(
                  state,
                  index,
                  dateFormat.format(state.eventList[index].date),
                ),
              _dismissibleEvent(state, index),
            ],
          );
        },
      ),
    );
  }

  Widget _eventDate(EventScreenState state, int index, String date) {
    return Column(
      children: [
        const SizedBox(height: 6),
        Align(
          alignment:
              BlocProvider.of<SettingsCubit>(context).state.isDateCenterAlign
                  ? Alignment.center
                  : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              date,
              style: TextStyle(
                fontSize:
                    BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dismissibleEvent(EventScreenState state, int index) {
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
        onTap: () => BlocProvider.of<EventScreenCubit>(context)
            .onTap(index, selectedChat.id),
        onLongPress: () =>
            BlocProvider.of<EventScreenCubit>(context).onLongPress(index),
        child: Align(
          alignment:
              BlocProvider.of<SettingsCubit>(context).state.isBubbleChatleft
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight,
          child: _event(state, index),
        ),
      ),
    );
  }

  void _dismiss(EventScreenState state, DismissDirection direction, int index) {
    if (state.selectedItemsCount == 0) {
      if (direction == DismissDirection.startToEnd) {}
      if (direction == DismissDirection.endToStart) {
        BlocProvider.of<EventScreenCubit>(context).deleteFromDismiss(
          index,
          selectedChat.id,
        );
      }
    }
  }

  Widget _event(EventScreenState state, int index) {
    final unselectedColor = Theme.of(context).colorScheme.primaryVariant;
    final selectedColor = Theme.of(context).colorScheme.secondaryVariant;

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
              LinkifyText(
                state.eventList[index].text,
                linkTypes: [LinkType.hashTag],
                textStyle: TextStyle(
                  fontSize:
                      BlocProvider.of<SettingsCubit>(context).state.fontSize,
                ),
                linkStyle: const TextStyle(color: Colors.blue),
                onTap: (link) => print(link.value),
              ),
            _eventTime(state, index),
          ],
        ),
      ),
    );
  }

  Widget _eventTime(EventScreenState state, int index) {
    final timeFormat = DateFormat('h:mm a');

    return Padding(
      padding: const EdgeInsets.only(top: 3, left: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.eventList[index].isSelected) _isSelectedItem(),
          Text(
            timeFormat.format(state.eventList[index].date).toString(),
            style: TextStyle(
              color: Colors.grey,
              fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
            ),
          ),
          AnimatedOpacity(
            opacity: state.eventList[index].isFavorite ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: _isFavoriteItem(),
          ),
        ],
      ),
    );
  }

  Widget _image(int index, EventScreenState state) {
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
        if (snapshot.connectionState == ConnectionState.done ||
            !snapshot.hasData) {
          return LottieBuilder.asset(
            'assets/loader.json',
            repeat: true,
            controller: _animController,
            onLoaded: (composition) {
              _animController.forward();
            },
          );
        }
        return LottieBuilder.asset(
          'assets/loader.json',
          repeat: true,
          controller: _animController,
          onLoaded: (composition) {
            _animController.forward();
          },
        );
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
            children: [
              const Icon(Icons.search, size: 35),
              Text(
                'Please enter a search query to begin serching',
                style: TextStyle(
                  fontSize:
                      BlocProvider.of<SettingsCubit>(context).state.fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyListOfMessagess(String subtext, EventScreenState state) {
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
                      style: TextStyle(
                        fontSize: BlocProvider.of<SettingsCubit>(context)
                            .state
                            .fontSize,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      subtext,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: BlocProvider.of<SettingsCubit>(context)
                            .state
                            .fontSize,
                      ),
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

  PreferredSizeWidget _customAppBar(EventScreenState state) {
    if (state.isEditing) {
      return PreferredSize(
        child: _editAppBar(),
        preferredSize: const Size(double.infinity, kToolbarHeight),
      );
    }

    if (state.selectedItemsCount > 0) {
      return _searchAppBar(state);
    }

    return PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        child: !state.isSearching
            ? _unselectedAppBar(state)
            : _searchAppBar(state));
  }

  PreferredSizeWidget _searchAppBar(EventScreenState state) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _searchController.clear();
          BlocProvider.of<EventScreenCubit>(context).changeParameters(
            isSearching: false,
            isEmpty: true,
            isShowFavorites: false,
          );
          BlocProvider.of<EventScreenCubit>(context)
              .showEvents(selectedChat.id);
        },
      ),
      title: _textField(state),
      actions: [
        !state.isTextFieldEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  BlocProvider.of<EventScreenCubit>(context)
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
          BlocProvider.of<EventScreenCubit>(context)
              .changeParameters(isEdit: false);
        },
      ),
      centerTitle: true,
      title: Text(
        'Editing Mode',
        style: TextStyle(
          fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
        ),
      ),
    );
  }

  PreferredSizeWidget _selectedAppBar(EventScreenState state) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () =>
            BlocProvider.of<EventScreenCubit>(context).unselectElements(),
      ),
      title: Text(
        '${state.selectedItemsCount}',
        style: TextStyle(
          fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _choosePage(state),
          icon: const Icon(Icons.reply),
        ),
        state.selectedItemsCount == 1
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _controller.text = BlocProvider.of<EventScreenCubit>(context)
                      .editMessageText();
                },
              )
            : Container(),
        IconButton(
          onPressed: () =>
              BlocProvider.of<EventScreenCubit>(context).copyText(),
          icon: const Icon(Icons.copy),
        ),
        IconButton(
          onPressed: () => BlocProvider.of<EventScreenCubit>(context)
              .addSelectedToFavorites(),
          icon: const Icon(Icons.bookmark_border),
        ),
        IconButton(
          onPressed: () =>
              BlocProvider.of<EventScreenCubit>(context).deleteElement(),
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Future _choosePage(EventScreenState state) {
    var chosenIndex = 0;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Select the page you want to migrate the selected event(s) to!',
            style: TextStyle(
              fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return _choseChatList(state, chosenIndex);
            },
          ),
          actions: [
            _textButton(chosenIndex),
          ],
        );
      },
    );
  }

  Widget _choseChatList(EventScreenState state, int chosenIndex) {
    return Container(
      height: 300,
      width: 300,
      child: ListView.builder(
        itemCount: state.chatList.length,
        itemBuilder: (context, index) {
          return RadioListTile(
            title: Text(
              state.chatList[index].elementName,
              style: TextStyle(
                fontSize:
                    BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
            ),
            value: index,
            groupValue: chosenIndex,
            onChanged: (index) {
              setState(() => chosenIndex = index as int);
            },
          );
        },
      ),
    );
  }

  Widget _textButton(int chosenIndex) {
    return TextButton(
      onPressed: () {
        BlocProvider.of<EventScreenCubit>(context)
            .moveMessageToAnotherChat(chosenIndex);
        Navigator.pop(context);
      },
      child: Text(
        'Ok',
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
        ),
      ),
    );
  }

  PreferredSizeWidget _unselectedAppBar(EventScreenState state) {
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
      title: Text(
        '${selectedChat.elementName}',
        style: TextStyle(
          fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            BlocProvider.of<EventScreenCubit>(context).changeParameters(
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

  IconButton _favoriteButton(EventScreenState state) {
    return IconButton(
      onPressed: () => BlocProvider.of<EventScreenCubit>(context)
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
    _animController.dispose();
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
