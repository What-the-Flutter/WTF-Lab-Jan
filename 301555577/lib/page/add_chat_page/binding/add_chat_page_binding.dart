import 'package:get/instance_manager.dart';

import '../../home/controller/home_controller.dart';
import '../controller/add_chat_page_controller.dart';

class AddChatPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddChatPageController());
    Get.lazyPut(() => HomeController());
  }
}
