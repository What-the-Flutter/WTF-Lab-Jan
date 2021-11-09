import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../../../model/chat_page.dart';

class HomeController extends GetxController {
  RxList<ChatPage> chatPageList = <ChatPage>[].obs;

  HomeController();

  void deleteChatPage(int index) {
    chatPageList.removeAt(index);
  }
}
