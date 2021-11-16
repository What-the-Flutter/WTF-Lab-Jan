import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/chat_page.dart';
import '../controller/chat_controller.dart';
import '../widgets/input.dart';

class ChatView extends GetView<ChatController> {
  ChatView({Key? key}) : super(key: key);

  final ChatPage category = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.title), actions: [
        Obx(() => Row(
              children: [
                if (controller.selectedMessage.value != 100000)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      controller.edit();
                    },
                  ),
                if (controller.selectedMessage.value != 100000)
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      controller.copyToClipboard();
                    },
                  ),
                if (controller.selectedMessage.value != 100000)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.delete();
                    },
                  ),
              ],
            )),
      ]),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  reverse: true,
                  itemCount: controller.messagesList.length,
                  itemBuilder: (context, index) {
                    var message = controller.messagesList.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onLongPress: () {
                                controller.selectMsg(index);
                                print(1);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: message.isSelected == true
                                      ? context.theme.primaryColor
                                      : context.theme.backgroundColor,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Text(
                                  message.textMessage,
                                  style: TextStyle(
                                    color: message.isSelected == true
                                        ? context.theme.backgroundColor
                                        : context.theme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          BottomInput(controller: controller)
        ],
      ),
    );
  }
}
