import 'dart:developer';

import 'package:chat_diary/src/data/firebase_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/app_home_cubit/app_cubit_observer.dart';
import 'src/theme/cubit/cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final userCredential = await FirebaseAuth.instance.signInAnonymously();
  final user = userCredential.user;
  if (user == null) {
    log('Anonymous auth failed');
  } else {
    log('Current user is $user');
  }
  BlocOverrides.runZoned(
    () async {
      final cubit = ThemeCubit();
      await cubit.loadTheme();
      runApp(
        BlocProvider<ThemeCubit>(
          create: (context) => cubit,
          child: const App(),
        ),
      );
    },
    blocObserver: AppCubitObserver(),
  );
}
