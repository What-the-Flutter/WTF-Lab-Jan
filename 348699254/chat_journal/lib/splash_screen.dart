import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/auth_cubit.dart';
import 'auth/auth_screen.dart';
import 'pages/main_page/main_page_screen.dart';
import 'pages/settings/settings_cubit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    authentication();
  }

  Future<void> authentication() async {
    if (BlocProvider.of<SettingsCubit>(context).isBiometricsAuthAbility()) {
      navigateUser();
    } else {
      BlocProvider.of<AuthCubit>(context)
          .signInAnonymously()
          .then((value) => moveToMainScreen());
      if (BlocProvider.of<AuthCubit>(context).isAuthorizedState()) {
        moveToMainScreen();
        print('Anonymously authorization');
      } else {
        print('Anonymously authorization failed');
      }
    }
  }

  void navigateUser() async {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AuthScreen()),
      ),
    );
  }

  void moveToMainScreen() async {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MainPageScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            width: 300,
            height: 300,
            child: Image.asset(
              'assets/splash_screen.jpg',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
