import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/theme.dart';
import '../../services/local_auth.dart';
import '../../theme/theme_cubit.dart';
import '../home/home.dart';
import 'app_cubit.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localAuth = LocalAuth();
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) async {
        if (state.appStates == AppStates.biometrics) {
          final result = await localAuth.authenticateWithBiometrics();
          context.read<AppCubit>().onAuthResult(result);
        }
      },
      builder: (context, state) {
        if (state.appStates == AppStates.loading) {
          return MaterialApp(
            title: 'Chat Journal',
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: backgroundColor,
              body: Center(
                child: SvgPicture.asset(
                  'assets/img/tree.svg',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          );
        } else if (state.appStates == AppStates.loaded ||
            state.appStates == AppStates.successBiometrics) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                title: 'Chat Journal',
                debugShowCheckedModeBanner: false,
                theme: themeState.themes.themeData,
                home: MyHomePage(),
              );
            },
          );
        } else if (state.appStates == AppStates.failedBiometrics) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                title: 'Chat Journal',
                debugShowCheckedModeBanner: false,
                theme: themeState.themes.themeData,
                home: Scaffold(
                  body: Center(
                    child: ElevatedButton(
                      onPressed: localAuth.authenticateWithBiometrics,
                      child: Text('Auth again'),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
