import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/pages_area.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          appBar: appBar(),
          drawer: const Drawer(),
          body: pagesArea(controller),
          bottomNavigationBar: bottomNavigationBar(context, controller),
        );
      },
    );
  }
}
