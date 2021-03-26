import 'package:flutter/material.dart';

class MessageTextFormField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;

  const MessageTextFormField({Key key, this.focusNode, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Your record',
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        minLines: 1,
        maxLines: 8,
        validator: (value) {
          if (value.trim().isEmpty) {
            return "Record can't be empty";
          }
          return null;
        },
        focusNode: focusNode,
        controller: controller,
      ),
    );
  }
}
