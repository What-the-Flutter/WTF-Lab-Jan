import 'package:get/instance_manager.dart';

import '../../pages.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ExploreController>(() => ExploreController());
    Get.lazyPut<TimelineController>(() => TimelineController());
    Get.lazyPut<DailyController>(() => DailyController());
  }
}
