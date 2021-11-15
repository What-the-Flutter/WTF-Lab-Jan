import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class FloatingActionBtn extends StatelessWidget {
  const FloatingActionBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(LineIcons.plus),
      onPressed: () {
        Get.toNamed('/add_chat_page');
      },
    );
  }
}
