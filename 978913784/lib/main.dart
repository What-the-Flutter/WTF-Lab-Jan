import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme.dart';
import 'home_page/home_page.dart';
import 'home_page/pages_cubit.dart';
import 'page.dart';


 void main() {
   WidgetsFlutterBinding.ensureInitialized();
   JournalPage.initCount();
   Event.initCount();
  runApp(BlocProvider(
    create: (context) => PagesCubit([])..init(),
    child: MyApp(),
  ));

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppTheme(
      key: AppThemeData.appThemeStateKey,
      child: MaterialApp(
        title: 'Chat Journal',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: HomePage(title: 'Flutter Demo Home Page'),
      ),

    );
  }
}
