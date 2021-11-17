import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Models/message.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this._message, this._isNewDate, this._isSelected, {Key? key})
      : super(key: key);

  final Message _message;
  final bool _isNewDate;
  final bool _isSelected;

  final double _textFontSize = 14.0;

  @override
  Widget build(BuildContext context) {
    var color = Colors.black26;

    if (_isNewDate) color = Colors.black45;
    if (_isSelected) color = Colors.blueGrey;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text.rich(_textSpan()),
    );
  }

  TextSpan _textSpan() {
    if (_isNewDate) {
      return TextSpan(
        style: const TextStyle(fontSize: 13),
        text: _message.formattedDate,
      );
    }
    return TextSpan(
      style: TextStyle(
        fontSize: _textFontSize,
      ),
      children: [
        if (_message.event != null) ...[
          WidgetSpan(
            child: Icon(_message.event!.value),
          ),
          TextSpan(
            text: '${_message.event!.key}\n',
          ),
          const WidgetSpan(
            child: SizedBox(height: 16),
          ),
          //TextSpan(text:'\n'),
        ],
        _message.image == null
            ? TextSpan(text: '${_message.text}\n')
            : WidgetSpan(
                child: kIsWeb
                    ? Image.network(_message.image!.path)
                    : Image.file(_message.image!),
              ),
        TextSpan(
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
          text: _message.formattedTime,
        ),
        if (_message.favourite)
          WidgetSpan(
            child: Icon(
              Icons.bookmark,
              size: _textFontSize,
              color: Colors.amber,
            ),
          ),
      ],
    );
  }
}
