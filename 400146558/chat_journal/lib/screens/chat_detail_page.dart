import 'package:chat_journal/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/services.dart';

List<Msg>? _messages = <Msg>[];
List<Msg>? _selected = <Msg>[];
bool? _isAnySelected = false;

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with TickerProviderStateMixin {
  bool? _isWriting;
  bool? _isNew;
  bool? _isShowFav;
  List<Msg>? _favourites = <Msg>[];

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _isWriting = false;
    _isNew = true;
    _isShowFav = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isAnySelected!
          ? AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).primaryColor,
              leading: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close),
                iconSize: 30.0,
                color: Colors.white,
                onPressed: _clearAll,
              ),
              title: Text(
                _selected!.length.toString(),
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
                    onPressed: () {},
                  ),
                ),
               const SizedBox(
                  width: 10,
                ),
                if (_selected!.length == 1) ...[
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
              backgroundColor: Theme.of(context).primaryColor,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  _isShowFav = false;
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              title: Text(
                widget.title!,
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
                  icon: _isShowFav!
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
            child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: _isShowFav! ? _favourites!.length : _messages!.length,
              itemBuilder: (context, index) => _msgWidget(index),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 60,
              width: double.infinity,
              color: Colors.white,
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
                      onSubmitted: _submitMsg,
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
        _isShowFav = true;
        _favourites =
            _messages!.where((element) => element.message.isFavourite == true)
                .toList();
      });
    }
  }

  void _addToFavourite() {
    if (mounted) {
      setState(() {
        for (var element in _messages!) {
          if (element.message.isSelected == true) {
            element.message.isFavourite = !element.message.isFavourite;
          }
        }
      });
    }

    _clearAll();
  }

  void _copyMsg() {
    var buffer = '';
    for (var element in _selected!) {
      buffer += element.message.message;
      buffer += '\n';
    }
    Clipboard.setData(ClipboardData(text: buffer));
  }

  void _deleteMsg() {
    if (mounted) {
      setState(() {
        _messages!.removeWhere((element) => element.message.isSelected == true);
        _selected!.clear();
        _selected!.isNotEmpty ? _isAnySelected = true : _isAnySelected = false;
        _selected!.isNotEmpty ? _isNew = true : _isNew = true;
      });
    }
  }

  void _clearAll() {
    if (mounted) {
      setState(() {
        for (var element in _messages!) {
          if (element.message.isSelected == true) {
            element.message.isSelected = false;
          }
        }
        _selected!.clear();
        _selected!.isNotEmpty ? _isAnySelected = true : _isAnySelected = false;
        _selected!.isNotEmpty ? _isNew = true : _isNew = true;
      });
    }
  }

  void _editMsg() {
    if (mounted) {
      _textController.text = _selected!.elementAt(0).message.message;
      _isNew = false;
    }
  }

  void _submitMsg(String txt) {
    if (_isNew == true) {
      _textController.clear();

      if (mounted) {
        setState(() {
          _isWriting = false;
        });
      }

      Message _currentMessage =
          Message(txt, Jiffy(DateTime.now()), false, false);

      Msg msg = Msg(
        message: _currentMessage,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 800)),
        notifyParent: refresh,
      );

      setState(() {
        _messages!.insert(0, msg);
      });

      msg.animationController!.forward();
    } else {
      setState(() {
        Msg editingMessage = _messages!
            .firstWhere((element) => element.message.isSelected == true);
        editingMessage.message.message = _textController.text;
        editingMessage.message.isSelected = false;
        _selected!.clear();
        _selected!.isNotEmpty ? _isAnySelected = true : _isAnySelected = false;
        _selected!.isNotEmpty ? _isNew = true : _isNew = true;
        _textController.clear();
      });
    }

    if (mounted) {
      setState(() {
        _isShowFav = false;
      });
    }
  }

  refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Msg extends StatefulWidget {
  const Msg(
      {Key? key,
      required this.message,
      this.animationController,
      required this.notifyParent})
      : super(key: key);

  final Message message;
  final AnimationController? animationController;
  final Function() notifyParent;

  @override
  _MsgState createState() => _MsgState();
}

class _MsgState extends State<Msg> {
  @override
  Widget build(BuildContext ctx) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: widget.animationController!, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: GestureDetector(
        onLongPress: _messageTools,
        onTap: _addToFavourite,
        child: Container(
          key: UniqueKey(),
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
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54)),
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
    );
  }

  void _messageTools() {
    if (mounted) {
      setState(() {
        widget.message.isSelected = !widget.message.isSelected;
        _selected!.clear();
        _selected = _messages!
            .where((element) => element.message.isSelected == true)
            .toList();
        _selected!.isNotEmpty ? _isAnySelected = true : _isAnySelected = false;
      });

      widget.notifyParent();
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

Msg _msgWidget(int index) {
  return Msg(
    message: _messages![index].message,
    animationController: _messages![index].animationController,
    notifyParent: _messages![index].notifyParent,
  );
}
