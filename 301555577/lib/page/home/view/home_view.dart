import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import '../widgets/chat_page_list_item.dart';
import '../widgets/floating_action_button.dart';
import '../widgets/slide_actions.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FloatingActionBtn(),
      body: Obx(
        () {
          return ListView.builder(
            itemCount: controller.chatPageList.length,
            itemBuilder: (context, index) {
              final chatPage = controller.chatPageList[index];
              return Slidable(
                actionPane: const SlidableDrawerActionPane(),
                actions: [
                  pinAction(context),
                  infoAction(context, chatPage),
                ],
                secondaryActions: [
                  editAction(context, index, chatPage),
                  deleteAction(context, index, controller),
                ],
                child: ChatPageListItem(chatPage: chatPage),
              );
            },
          );
        },
      ),
    );
  }
}
