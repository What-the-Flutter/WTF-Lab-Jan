import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../controller/dashboard_controller.dart';

Container bottomNavigationBar(
    BuildContext context, DashboardController controller) {
  return Container(
    decoration: BoxDecoration(
      color: context.theme.backgroundColor,
      boxShadow: [
        BoxShadow(
          blurRadius: 4,
          color: Colors.black.withOpacity(0.2),
        )
      ],
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: GNav(
          rippleColor: Colors.grey[200]!,
          hoverColor: Colors.grey[200]!,
          gap: 8,
          activeColor: context.theme.primaryColor,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: context.theme.canvasColor,
          color: context.theme.primaryColor,
          tabs: const [
            GButton(
              icon: LineIcons.home,
              text: 'Home',
            ),
            GButton(
              icon: LineIcons.tasks,
              text: 'Daily',
            ),
            GButton(
              icon: LineIcons.map,
              text: 'Timeline',
            ),
            GButton(
              icon: Icons.explore_outlined,
              text: 'Explore',
            ),
          ],
          selectedIndex: controller.tabIndex,
          onTabChange: (index) => controller.changeTabIndex(index),
        ),
      ),
    ),
  );
}
