import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

import '../controller/chat_controller.dart';

class BottomInput extends StatelessWidget {
  final ChatController controller;

  const BottomInput({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        top: 10,
        right: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: context.theme.backgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            const Icon(
              Icons.camera_alt_outlined,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: context.theme.canvasColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sentiment_satisfied_alt_outlined),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controller.textInputController.value,
                        decoration: const InputDecoration(
                          hintText: 'Type message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.attach_file_outlined),
                  ],
                ),
              ),
            ),
            // const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: controller.send,
            ),
          ],
        ),
      ),
    );
  }
}
