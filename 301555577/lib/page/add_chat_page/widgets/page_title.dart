import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/add_chat_page_controller.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AddChatPageController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.only(top: 100),
        child: Obx(() => Text(
              controller.title.value,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
