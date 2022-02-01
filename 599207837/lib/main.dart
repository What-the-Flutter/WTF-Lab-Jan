import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'database/firebase/realtime_db_provider.dart';
import 'database/preferences.dart';
import 'widgets/theme_provider/theme_cubit.dart';
import 'widgets/theme_provider/theme_state.dart';
import 'widgets/widgets.dart';

late final String userID;

void main() => initApp().whenComplete(() => runApp(const MyApp()));

Future<void> initApp() async {
  await Preferences.lookUpToPreferences();
  await FireBaseProvider.initFirebase();
  await FirebaseAuth.instance.signInAnonymously();
  var user = await FirebaseAuth.instance.currentUser;
  userID = user!.uid;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) => const MaterialApp(
          title: 'Flutter Demo',
          home: ItemsPage(),
        ),
      ),
    );
  }
}
