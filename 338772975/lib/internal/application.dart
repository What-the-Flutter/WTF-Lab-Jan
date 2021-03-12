import 'package:flutter/material.dart';

import '../presentation/home/home_page.dart';
import '../theme.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.purpleTheme,
      routes: {
        HomePage.routeName: (_) => const HomePage(),
      },
    );
  }
}
