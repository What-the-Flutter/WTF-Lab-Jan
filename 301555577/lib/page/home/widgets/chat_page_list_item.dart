import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

import '../../../model/chat_page.dart';

class ChatPageListItem extends StatelessWidget {
  const ChatPageListItem({
    Key? key,
    required this.chatPage,
  }) : super(key: key);

  final ChatPage chatPage;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          height: 90,
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.black.withOpacity(0.1))),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Icon(chatPage.icon, size: 36),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatPage.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    chatPage.messages.isEmpty
                        ? 'No events. Click to create one'
                        : chatPage.messages.first.textMessage,
                  )
                ],
              ),
              const Spacer(),
              Text(
                chatPage.messages.isEmpty
                    ? ''
                    : '${chatPage.lastUpdate.hour}:${chatPage.lastUpdate.minute}',
                style: TextStyle(
                    color: context.theme.primaryColor.withOpacity(0.4)),
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
        onTap: () => Get.toNamed('/chat', arguments: chatPage),
      ),
    );
  }
}
