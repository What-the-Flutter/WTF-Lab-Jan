import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageChatElement extends StatefulWidget {
  MessageChatElement({
    required Key? key,
    required this.mainText,
    required this.subscribeMessage,
    required this.unsubscribeMessage,
  }) : super(key: key);

  String mainText;
  final String currentTime = DateFormat.jm().format(DateTime.now().toLocal());
  bool isSelected = false;
  bool isFavorite = false;
  final Function unsubscribeMessage;
  final Function subscribeMessage;

  @override
  MessageChatElementState createState() => MessageChatElementState();
}

class MessageChatElementState extends State<MessageChatElement> {
  Color color = const Color.fromRGBO(213, 237, 213, 1);

  Widget _isSelectedItem() {
    return Row(
      children: [
        const Icon(
          Icons.check_circle,
          size: 15,
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  void selectItem() {
    widget.isSelected = !widget.isSelected;
    if (widget.isSelected) {
      widget.subscribeMessage(widget.key);
      color = const Color.fromRGBO(188, 226, 200, 1);
    } else {
      widget.unsubscribeMessage(widget.key);
      color = const Color.fromRGBO(213, 237, 213, 1);
    }
    setState(() {});
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

  void _selectFavorite() {
    _isFavoriteItem();
    widget.isFavorite = !widget.isFavorite;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isSelected ? selectItem : _selectFavorite,
      onLongPress: selectItem,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 369),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding:
                const EdgeInsets.only(right: 18, bottom: 6, top: 10, left: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mainText,
                  style: const TextStyle(fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isSelected) _isSelectedItem(),
                      Text(
                        widget.currentTime.toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      if (widget.isFavorite) _isFavoriteItem(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
