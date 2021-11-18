import 'package:chat_journal/models/globals.dart';
import 'package:chat_journal/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/services.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({Key? key, this.chatIndex}) : super(key: key);
  final int? chatIndex;

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with TickerProviderStateMixin {
  bool? _isWriting = false;
  bool? _isNew = true;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isAnySelected!
          ? AppBar(
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
                selected!.length.toString(),
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                    onPressed: () {},
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (selected!.length == 1) ...[
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.edit),
                    iconSize: 30.0,
                    color: Colors.white,
                    onPressed: _editMsg,
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
                  onPressed: _deleteMsg,
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            )
          : AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  isShowFav = false;
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              title: Text(
                chats[widget.chatIndex!].title,
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
                  onPressed: () {},
                ),
                IconButton(
                  icon: isShowFav!
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_outline),
                  iconSize: 30.0,
                  color: Colors.white,
                  onPressed: _showFavourites,
                ),
              ],
            ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: isShowFav!
                    ? favourites!.length
                    : chats[widget.chatIndex!].messageBase!.length,
                itemBuilder: _msgWidget,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 60,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.workspaces_filled),
                    iconSize: 30.0,
                    color: Colors.green,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      enabled: true,
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
                        setState(() {
                          _isWriting = text.isNotEmpty;
                        });
                      },
                      onSubmitted: isAnySelected! ? null : _submitMsg,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Stack(
                    children: <Widget>[
                      Visibility(
                        visible: _isWriting == true ? true : false,
                        child: IconButton(
                          icon: const Icon(Icons.send),
                          iconSize: 30.0,
                          color: Colors.green,
                          onPressed: () {
                            setState(() {
                              _submitMsg(_textController.text);
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: _isWriting == false ? true : false,
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

  void _showFavourites() {
    if (mounted) {
      setState(() {
        favourites = chats[widget.chatIndex!]
            .messageBase!
            .where((element) => element.isFavourite == true)
            .toList();
        isShowFav = !isShowFav!;
      });
    }
  }

  void _addToFavourite() {
    if (mounted) {
      setState(() {
        for (var element in chats[widget.chatIndex!].messageBase!) {
          if (element.isSelected == true) {
            element.isFavourite = !element.isFavourite;
          }
        }
      });
    }

    _clearAll();
  }

  void _copyMsg() {
    var buffer = '';
    for (var element in selected!) {
      buffer += element.message;
      buffer += '\n';
    }
    Clipboard.setData(ClipboardData(text: buffer));
  }

  void _deleteMsg() {
    if (mounted) {
      setState(() {
        chats[widget.chatIndex!]
            .messageBase!
            .removeWhere((element) => element.isSelected == true);
        selected!.clear();
        selected!.isNotEmpty ? isAnySelected = true : isAnySelected = false;
        selected!.isNotEmpty ? _isNew = true : _isNew = true;
      });
    }
  }

  void _clearAll() {
    if (mounted) {
      setState(() {
        for (var element in chats[widget.chatIndex!].messageBase!) {
          if (element.isSelected == true) {
            element.isSelected = false;
          }
        }
        selected!.clear();
        selected!.isNotEmpty ? isAnySelected = true : isAnySelected = false;
        selected!.isNotEmpty ? _isNew = true : _isNew = true;
      });
    }
  }

  void _editMsg() {
    if (mounted) {
      _textController.text = selected!.elementAt(0).message;
      _isNew = false;
    }
  }

  void _submitMsg(String txt) {
    if (_isNew == true) {
      _textController.clear();

      Message _currentMessage =
          Message(txt, Jiffy(DateTime.now()), false, false);
      if (mounted) {
        setState(() {
          chats[widget.chatIndex!].messageBase!.insert(0, _currentMessage);
          _isWriting = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          Message editingMessage = chats[widget.chatIndex!]
              .messageBase!
              .firstWhere((element) => element.isSelected == true);
          editingMessage.message = _textController.text;
          editingMessage.isSelected = false;
          selected!.clear();
          selected!.isNotEmpty ? isAnySelected = true : isAnySelected = false;
          selected!.isNotEmpty ? _isNew = true : _isNew = true;
          _textController.clear();
        });
      }
    }

    if (mounted) {
      setState(() {
        isShowFav = false;
      });
    }
  }

  refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _msgWidget(BuildContext context, int index) {
    var msg = Msg(
      message: isShowFav!
          ? favourites![index]
          : chats[widget.chatIndex!].messageBase![index],
      chatIndex: widget.chatIndex!,
      notifyParent: refresh,
    );
    return msg;
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
    if (mounted) {
      setState(() {
        widget.message.isSelected = !widget.message.isSelected;
        selected!.clear();
        selected = chats[widget.chatIndex]
            .messageBase!
            .where((element) => element.isSelected == true)
            .toList();
        selected!.isNotEmpty ? isAnySelected = true : isAnySelected = false;

        widget.notifyParent();
      });
    }
  }

  void _addToFavourite() {
    if (mounted) {
      setState(() {
        widget.message.isFavourite = !widget.message.isFavourite;
      });
    }
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
