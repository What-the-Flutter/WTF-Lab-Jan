import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum PopupAction { edit, delete, pin }

class ActionPopupMenuEntry extends PopupMenuEntry<PopupAction> {
  final PopupAction action;
  final String name;
  final Color color;

  ActionPopupMenuEntry({Key? key, required this.action, required this.name, required this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ActionPopupMenuEntryState();

  @override
  double get height => 10;

  @override
  bool represents(PopupAction? value) {
    return value != null;
  }
}

class _ActionPopupMenuEntryState extends State<ActionPopupMenuEntry> {
  void _onTap() {
    Navigator.of(context).pop(widget.action);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        widget.name,
        style: TextStyle(color: widget.color),
      ),
      onPressed: _onTap,
    );
  }
}
