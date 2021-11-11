
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'page/pages.dart';
import 'theme/theme.dart';

void main() {
  runApp(const Diary());
}

class Diary extends StatelessWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diary',
      theme: Themes.light,
      darkTheme: Themes.dark,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const DashboardView(),
          binding: DashboardBinding(),
        ),
        GetPage(
          name: '/add_chat_page',
          page: () => const AddChatPageView(),
          binding: AddChatPageBinding(),
        ),
        GetPage(
          name: '/chat',
          page: () => ChatView(),
          binding: ChatBinding(),
        ),
      ],
    );
  }
}
