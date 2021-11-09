import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

import '../controller/add_chat_page_controller.dart';

class IconsGrid extends StatelessWidget {
  const IconsGrid({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AddChatPageController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Obx(
        () {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              shrinkWrap: true,
              itemCount: controller.icons.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: controller.iconSelected == index
                            ? context.theme.primaryColor
                            : context.theme.backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4),
                        ],
                      ),
                      margin: const EdgeInsets.all(8),
                      child: Center(
                        child: Icon(
                          controller.icons[index],
                          size: 36,
                          color: controller.iconSelected == index
                              ? context.theme.backgroundColor
                              : context.theme.primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            controller.selectIcon(index);
                            controller.checkPageParams();
                          },
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
