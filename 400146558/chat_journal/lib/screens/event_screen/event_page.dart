import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/models/message_model.dart';
import 'package:chat_journal/screens/event_screen/event_cubit.dart';
import 'package:chat_journal/screens/home_screen/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'event_state.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage(
      {Key? key, required this.chatIndex, required this.currentChat})
      : super(key: key);
  final int chatIndex;
  final Chat? currentChat;

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<EventCubit>(context).init();
    BlocProvider.of<EventCubit>(context).myInit(widget.currentChat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
        return state.searchMode! ? _searchPage(state) : _messagePage(state);
      },
    );
  }

  AppBar _appBarMessage(EventState state) {
    if (state.isAnySelected! == true) {
      return _editMenu(state);
    } else {
      return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            BlocProvider.of<EventCubit>(context).setShowFav(false);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          widget.currentChat!.title,
          style: const TextStyle(
            fontFamily: 'Merriweather',
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              BlocProvider.of<EventCubit>(context).setSearchMode(true);
            },
          ),
          IconButton(
            icon: state.isShowFav!
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_outline),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: _showFavourites,
          ),
        ],
      );
    }
  }

  AppBar _appBarSearch(EventState state) {
    if (state.isAnySelected! == true) {
      return _editMenu(state);
    } else {
      return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: IconButton(
          onPressed: () {
            BlocProvider.of<EventCubit>(context).setSearchMode(false);
            _searchController.clear();
            BlocProvider.of<EventCubit>(context).foundedClear();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: TextField(
          autofocus: true,
          controller: _searchController,
          maxLines: null,
          decoration: InputDecoration(
              hintText: "Search in '${state.currentChat!.title}'",
              hintStyle: const TextStyle(color: Colors.black54),
              fillColor: Theme.of(context).cardColor,
              filled: true,
              border: InputBorder.none),
          onChanged: (text) {
            _searchMessage(text);
            BlocProvider.of<EventCubit>(context).setIsWriting(text.isNotEmpty);
            BlocProvider.of<EventCubit>(context).setShowPanel(false);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear_outlined),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              _searchController.clear();
              BlocProvider.of<EventCubit>(context).foundedClear();
            },
          ),
        ],
      );
    }
  }

  AppBar _editMenu(EventState state) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      leading: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.close),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: _clearAll,
      ),
      title: Text(
        state.selected!.length.toString(),
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        Transform.rotate(
          angle: 180 * 3.14 / 180,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.forward),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              _replyEvents(state);
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        if (state.selected!.length == 1) ...[
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.edit),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () => _editMsg(state),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.copy),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: _copyMsg,
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.favorite_outline_rounded),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: _addToFavourite,
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.delete),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () => _deleteMsg(state),
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  Scaffold _messagePage(EventState state) {
    return Scaffold(
      appBar: _appBarMessage(state),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: state.isShowFav!
                    ? state.favourites!.length
                    : state.currentChat?.messageBase?.length,
                itemBuilder: (BuildContext context, int index) {
                  return _msgWidget(index, state);
                },
              ),
            ),
          ),
          if (state.showPanel!) ...[
            Container(
              height: 70.0,
              padding: const EdgeInsets.all(5.0),
              color: Theme.of(context).primaryColor,
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: state.sectionsList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _sectionPanel(index, state);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 60,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: _sectionIcon(state),
                    iconSize: 30.0,
                    color: Colors.green,
                    onPressed: () {
                      BlocProvider.of<EventCubit>(context)
                          .setShowPanel(!state.showPanel!);
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: "Enter Event",
                          hintStyle: const TextStyle(color: Colors.black54),
                          fillColor: Colors.green[200],
                          filled: true,
                          border: InputBorder.none),
                      onChanged: (text) {
                        BlocProvider.of<EventCubit>(context)
                            .setIsWriting(text.isNotEmpty);
                        BlocProvider.of<EventCubit>(context)
                            .setShowPanel(false);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Stack(
                    children: <Widget>[
                      Visibility(
                        visible: state.isWriting == true ? true : false,
                        child: IconButton(
                          icon: const Icon(Icons.send),
                          iconSize: 30.0,
                          color: Colors.green,
                          onPressed: () {
                            _submitMsg(_textController.text, state);
                          },
                        ),
                      ),
                      Visibility(
                        visible: state.isWriting == false ? true : false,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt),
                          iconSize: 30.0,
                          color: Colors.green,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Scaffold _searchPage(EventState state) {
    return Scaffold(
      appBar: _appBarSearch(state),
      body: Column(
        children: <Widget>[
          _searchResult(state),
          if (state.showPanel!) ...[
            Container(
              height: 70.0,
              padding: const EdgeInsets.all(5.0),
              color: Theme.of(context).primaryColor,
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: state.sectionsList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _sectionPanel(index, state);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (state.editMode == true) ...[
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 60,
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: _sectionIcon(state),
                      iconSize: 30.0,
                      color: Colors.green,
                      onPressed: () {
                        BlocProvider.of<EventCubit>(context)
                            .setShowPanel(!state.showPanel!);
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: "Enter Event",
                            hintStyle: const TextStyle(color: Colors.black54),
                            fillColor: Colors.green[200],
                            filled: true,
                            border: InputBorder.none),
                        onChanged: (text) {
                          BlocProvider.of<EventCubit>(context)
                              .setIsWriting(text.isNotEmpty);
                          BlocProvider.of<EventCubit>(context)
                              .setShowPanel(false);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Stack(
                      children: <Widget>[
                        Visibility(
                          visible: state.isWriting == true ? true : false,
                          child: IconButton(
                            icon: const Icon(Icons.send),
                            iconSize: 30.0,
                            color: Colors.green,
                            onPressed: () {
                              _submitMsg(_textController.text, state);
                            },
                          ),
                        ),
                        Visibility(
                          visible: state.isWriting == false ? true : false,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt),
                            iconSize: 30.0,
                            color: Colors.green,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _searchResult(EventState state) {
    if (state.foundList!.isNotEmpty && _searchController.text.isNotEmpty) {
      return Expanded(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: ListView.builder(
            shrinkWrap: true,
            reverse: true,
            itemCount: state.foundList!.length,
            itemBuilder: (BuildContext context, int index) {
              return _msgWidget(index, state);
            },
          ),
        ),
      );
    } else if (state.foundList!.isEmpty && _searchController.text.isNotEmpty) {
      return Container(
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'No search results available.',
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'No entries match the given search query. \nPlease try again.',
                style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.search,
                color: Colors.black,
                size: 70.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Please enter a search query to begin searching.',
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }

  void _replyEvents(EventState state) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Text(
                  'Select the page you want '
                  'to migrate the selected '
                  'event(s) to!',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<EventCubit, EventState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 200,
                    width: 300,
                    child: _replyEventListView(state),
                  );
                },
              ),
              _replyDialogButtons(state),
            ],
          ),
        );
      },
    );
  }

  ListView _replyEventListView(EventState state) {
    return ListView.builder(
      itemCount: context.read<HomeCubit>().state.chatsList.length,
      itemBuilder: (context, index) {
        return RadioListTile(
          title: Text(
            context.read<HomeCubit>().state.chatsList[index].title,
          ),
          activeColor: Colors.redAccent,
          value: index,
          groupValue: state.replyChatIndex,
          onChanged: (value) => context
              .read<EventCubit>()
              .setReplyCategory(context, value as int),
        );
      },
    );
  }

  Widget _replyDialogButtons(EventState state) {
    return Row(
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<EventCubit>(context).replyEvents();
            Navigator.pop(context);
          },
          child: const Text(
            'Move',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
            ),
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  void _searchMessage(String txt) {
    BlocProvider.of<EventCubit>(context).searchMsg(txt);
  }

  Widget _sectionIcon(EventState state) {
    var secIconIndex =
        state.sectionsList!.indexWhere((element) => element.isSelected == true);
    if (secIconIndex == -1) {
      return const Icon(Icons.workspaces_filled);
    } else {
      return Icon(state.sectionsList![secIconIndex].icon);
    }
  }

  void _showFavourites() {
    BlocProvider.of<EventCubit>(context).showFavourites();
  }

  void _addToFavourite() {
    BlocProvider.of<EventCubit>(context).addToFavourites();
  }

  void _copyMsg() {
    BlocProvider.of<EventCubit>(context).copyMsg();
  }

  void _deleteMsg(EventState state) {
    BlocProvider.of<EventCubit>(context).deleteMsg();
    BlocProvider.of<EventCubit>(context).setIsNew(true);
    if (state.searchMode!) {
      _searchMessage(_searchController.text);
    }
  }

  void _clearAll() {
    BlocProvider.of<EventCubit>(context).cancelSelection();
    BlocProvider.of<EventCubit>(context).setIsNew(true);
  }

  void _editMsg(EventState state) {
    BlocProvider.of<EventCubit>(context).setEditMode(true);

    _textController.text = state.selected!.elementAt(0).message;
    var _secIcoEditingIndex = state.sectionsList!.indexWhere(
        (element) => element == state.selected!.elementAt(0).section);
    if (_secIcoEditingIndex != -1) {
      BlocProvider.of<EventCubit>(context).check(_secIcoEditingIndex);
    }
    BlocProvider.of<EventCubit>(context).setIsNew(false);
  }

  void _submitMsg(String txt, EventState state) {
    if (state.isNew == true) {
      _textController.clear();
      Message _currentMessage;

      var _secIconIndex = state.sectionsList!
          .indexWhere((element) => element.isSelected == true);
      if (_secIconIndex == -1) {
        _currentMessage =
            Message(txt, Jiffy(DateTime.now()), false, false, null);
      } else {
        _currentMessage = Message(txt, Jiffy(DateTime.now()), false, false,
            state.sectionsList![_secIconIndex]);
      }

      BlocProvider.of<EventCubit>(context).addMsg(_currentMessage);
      BlocProvider.of<EventCubit>(context).setIsWriting(false);
    } else {
      BlocProvider.of<EventCubit>(context).editMsg(_textController.text);
      BlocProvider.of<EventCubit>(context).setIsNew(true);
      _textController.clear();
    }

    BlocProvider.of<EventCubit>(context).setShowFav(false);
    BlocProvider.of<EventCubit>(context).uncheck();
    BlocProvider.of<EventCubit>(context).setShowPanel(false);
    BlocProvider.of<EventCubit>(context).setEditMode(false);
  }

  refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _msgWidget(int index, EventState state) {
    if (state.searchMode == true) {
      return Msg(
        message: state.foundList![index],
        chatIndex: widget.chatIndex,
        notifyParent: refresh,
      );
    } else {
      return Msg(
        message: state.isShowFav!
            ? state.favourites![index]
            : state.currentChat!.messageBase![index],
        chatIndex: widget.chatIndex,
        notifyParent: refresh,
      );
    }
  }

  void _selectSection(int index, EventState state) {
    if (index == 0) {
      BlocProvider.of<EventCubit>(context).setShowPanel(!state.showPanel!);
    } else {
      BlocProvider.of<EventCubit>(context).check(index);
    }
  }

  Widget _sectionPanel(int index, EventState state) {
    return GestureDetector(
      onTap: () => _selectSection(index, state),
      child: Row(
        children: [
          Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: index == 0 ? Colors.red : Colors.grey,
                radius: index == 0 ? 10.0 : 20.0,
                child: Icon(
                  state.sectionsList![index].icon,
                  color: Colors.white,
                  size: index == 0 ? 10.0 : 20.0,
                ),
              ),
              Text(
                state.sectionsList![index].title,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          ),
          const SizedBox(
            width: 7.0,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Msg extends StatefulWidget {
  const Msg(
      {Key? key,
      required this.chatIndex,
      required this.message,
      required this.notifyParent})
      : super(key: key);

  final int chatIndex;
  final Message message;
  final Function() notifyParent;

  @override
  _MsgState createState() => _MsgState();
}

class _MsgState extends State<Msg> {
  @override
  Widget build(BuildContext ctx) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            // Swiping in right direction.
            if (details.delta.dx > 0) {}

            // Swiping in left direction.
            if (details.delta.dx < 0) {}
          },
          onLongPress: _messageTools,
          onTap: _addToFavourite,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.lightGreenAccent,
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.message.section != null) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        widget.message.section!.icon,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                        child: Text(widget.message.section!.title,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: Text(widget.message.message,
                          style: const TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if (widget.message.isSelected == true) ...[
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.check_circle),
                        color: Colors.black,
                        iconSize: 12,
                        onPressed: () {},
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                    ],
                    Text(widget.message.time.Hm,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54)),
                    if (widget.message.isFavourite == true) ...[
                      const SizedBox(
                        width: 7,
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.favorite),
                        color: Colors.red,
                        iconSize: 12,
                        onPressed: () {},
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _messageTools() {
    BlocProvider.of<EventCubit>(context).messageTools(widget.message);
    widget.notifyParent();
  }

  void _addToFavourite() {
    BlocProvider.of<EventCubit>(context).addToFavouriteOnTap(widget.message);
  }
}

class MsgTime extends StatelessWidget {
  const MsgTime({
    Key? key,
    required this.message,
    this.animationController,
  }) : super(key: key);

  final Message message;
  final AnimationController? animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController!, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        key: UniqueKey(),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.redAccent,
        ),
        padding: const EdgeInsets.all(8),
        child: Text(
          message.time.fromNow(),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
