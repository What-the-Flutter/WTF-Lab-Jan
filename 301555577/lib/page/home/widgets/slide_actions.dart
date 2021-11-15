import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:line_icons/line_icons.dart';

import '../../../model/chat_page.dart';
import '../controller/home_controller.dart';

IconSlideAction deleteAction(
    BuildContext context, int index, HomeController controller) {
  return IconSlideAction(
    foregroundColor: context.theme.primaryColor,
    color: context.theme.backgroundColor,
    caption: 'Delete',
    icon: LineIcons.trash,
    onTap: () => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to delete the page?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'No',
              style: TextStyle(color: context.theme.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deleteChatPage(index);
              Get.back();
            },
            child: Text(
              'Yes',
              style: TextStyle(color: context.theme.primaryColor),
            ),
          ),
        ],
      ),
    ),
  );
}

IconSlideAction editAction(BuildContext context, int index, ChatPage chatPage) {
  return IconSlideAction(
    foregroundColor: context.theme.primaryColor,
    color: context.theme.backgroundColor,
    caption: 'Edit',
    icon: LineIcons.edit,
    onTap: () => Get.toNamed('/add_chat_page', arguments: [index, chatPage]),
  );
}

IconSlideAction infoAction(BuildContext context, ChatPage chatPage) {
  return IconSlideAction(
    foregroundColor: context.theme.primaryColor,
    color: context.theme.backgroundColor,
    caption: 'Info',
    icon: LineIcons.infoCircle,
    onTap: () {
      showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: context.theme.backgroundColor,
          title: const Text(
            'Info',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title  -  ${chatPage.title}'),
                Text(
                    'Created time  -  ${chatPage.createdTime.hour} : ${chatPage.createdTime.minute}'),
                Text(
                    'Day  -  ${chatPage.createdTime.day} : ${chatPage.createdTime.month} : ${chatPage.createdTime.year}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                'OK',
                style: TextStyle(color: context.theme.primaryColor),
              ),
            ),
          ],
        ),
      );
    },
  );
}

IconSlideAction pinAction(BuildContext context) {
  return IconSlideAction(
    foregroundColor: context.theme.primaryColor,
    color: context.theme.backgroundColor,
    caption: 'Pin',
    icon: LineIcons.thumbtack,
    onTap: () {},
  );
}
