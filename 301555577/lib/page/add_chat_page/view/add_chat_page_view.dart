import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/add_chat_page_controller.dart';
import '../widgets/floating_action_button.dart';
import '../widgets/icons_grid.dart';
import '../widgets/page_title.dart';
import '../widgets/page_title_text_field.dart';

class AddChatPageView extends GetView<AddChatPageController> {
  const AddChatPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton(controller),
      body: Column(
        children: [
          PageTitle(controller: controller),
          PageTitleTextField(controller: controller),
          IconsGrid(controller: controller),
        ],
      ),
    );
  }
}
