import 'package:get/instance_manager.dart';

import '../controller/chat_controller.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
  }
}
