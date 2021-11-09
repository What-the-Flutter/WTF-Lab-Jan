import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

import '../controller/add_chat_page_controller.dart';

class PageTitleTextField extends StatelessWidget {
  const PageTitleTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AddChatPageController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 70, bottom: 10, right: 70),
      child: TextField(
        textAlign: TextAlign.center,
        controller: controller.pageTitleController.value,
        onChanged: (text) {
          controller.checkPageParams();
        },
        cursorColor: context.theme.primaryColor,
        decoration: InputDecoration(
          hintText: 'Category title',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: context.theme.primaryColor,
              width: 2.0,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
