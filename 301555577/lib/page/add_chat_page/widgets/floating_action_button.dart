import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../pages.dart';

Obx floatingActionButton(AddChatPageController controller) {
  return Obx(
    () => FloatingActionButton(
      child: controller.status
          ? const Icon(LineIcons.plus)
          : const Icon(LineIcons.times),
      onPressed: () {
        if (controller.status) {
          controller.addChatPage();
          Get.back();
        } else {
          Get.back();
        }
      },
    ),
  );
}
