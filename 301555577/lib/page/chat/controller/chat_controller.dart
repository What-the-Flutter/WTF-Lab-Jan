// import 'package:diary/model/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../model/chat_page.dart';
import '../../../model/item_message.dart';
import '../../home/controller/home_controller.dart';

class ChatController extends GetxController {
  late ChatPage category;

  RxList<ItemMessage> messagesList = <ItemMessage>[].obs;
  Rx<TextEditingController> textInputController = TextEditingController().obs;
  final _homeController = Get.find<HomeController>();

  Rx<int> selectedMessage = 100000.obs;
  final RxBool _isEditMode = false.obs;

  ChatController() {
    category = Get.arguments;
    messagesList.clear();
    messagesList.addAll(category.messages);
  }

  void chatRefresh() {
    messagesList.clear();
    messagesList.addAll(category.messages);
    _homeController.chatPageList.refresh();
    messagesList.refresh();
  }

  void selectClean() {
    for (var element in messagesList) {
      element.isSelected = false;
    }
  }

  void send() {
    if (textInputController.value.text.isNotEmpty) {
      var msg = ItemMessage(
        id: const Uuid().v1(),
        textMessage: textInputController.value.text,
        messageTime: DateTime.now(),
      );

      if (_isEditMode.isFalse) {
        category.messages.insert(0, msg);
        category.lastUpdate = DateTime.now();
        textInputController.value.clear();
        chatRefresh();
      } else {
        category.messages.elementAt(selectedMessage.value).textMessage =
            textInputController.value.text;
        category.lastUpdate = DateTime.now();
        chatRefresh();
        _isEditMode.toggle();

        selectedMessage.value = 100000;
        textInputController.value.clear();
        selectClean();
      }
    }
  }

  void delete() {
    if (selectedMessage != 100000.obs) {
      category.messages.removeAt(selectedMessage.value);
      selectClean();
      chatRefresh();
      selectedMessage.value = 100000;
    }
  }

  void copyToClipboard() {
    if (selectedMessage != 100000.obs) {
      Clipboard.setData(ClipboardData(
          text: messagesList.elementAt(selectedMessage.value).textMessage));
    }
  }

  void edit() {
    if (selectedMessage != 100000.obs) {
      textInputController.value.text =
          messagesList.elementAt(selectedMessage.value).textMessage;
      _isEditMode.toggle();
    }
  }

  void selectMsg(int index) {
    if (messagesList.elementAt(index).isSelected == true &&
        selectedMessage.value == index) {
      selectClean();
      selectedMessage.value = 100000;
    } else {
      selectClean();
      selectedMessage.value = index;
      messagesList.elementAt(index).isSelected = true;
    }
    messagesList.refresh();
  }
}
