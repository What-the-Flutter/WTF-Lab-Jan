import 'package:flutter/material.dart';

import '../../pages.dart';
import '../controller/dashboard_controller.dart';

SafeArea pagesArea(DashboardController controller) {
  return SafeArea(
    child: IndexedStack(
      index: controller.tabIndex,
      children: const [
        HomeView(),
        DailyView(),
        TimelineView(),
        ExploreView(),
      ],
    ),
  );
}
