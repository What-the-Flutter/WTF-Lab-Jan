import 'package:chat_journal/auth.dart';
import 'package:chat_journal/screens/create_screen/create_cubit.dart';
import 'package:chat_journal/screens/event_screen/event_cubit.dart';
import 'package:chat_journal/screens/home_screen/home_page.dart';
import 'package:chat_journal/theme/theme_cubit.dart';
import 'package:chat_journal/theme/theme_state.dart';
import 'package:chat_journal/screens/home_screen/home_cubit.dart';
import 'package:chat_journal/util/shared_preferences_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  await SharedPreferencesProvider.initialize();
  final AuthService _auth = AuthService();
  dynamic result = await _auth.signInAnon();
  if(result == null) {
    debugPrint('error signing in');
  } else {
    debugPrint('signed in');
    debugPrint(result.toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<CreatePageCubit>(create: (context) => CreatePageCubit()),
        BlocProvider<EventCubit>(create: (context) => EventCubit())
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat Journal',
            theme: state.themeData,
            home: const HomePage(),
            // routes: {'/create-page': (context) => CreatePage()},
          );
        },
      ),
    );
  }
}
