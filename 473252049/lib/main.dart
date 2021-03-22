import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication_cubit/authentication_cubit.dart';
import 'pages/main/main_page.dart';
import 'pages/main/tabs/home/cubit/categories_cubit.dart';
import 'pages/settings/cubit/settings_cubit.dart';
import 'repositories/local_database/local_database_categories_repository.dart';

class CubitsObserver extends BlocObserver {
  @override
  void onChange(BlocBase cubit, Change change) {
    print('$cubit $change');
    super.onChange(cubit, change);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = CubitsObserver();
  final preferences = await SharedPreferences.getInstance();
  runApp(
    BlocProvider(
      create: (context) => SettingsCubit(
        preferences: preferences,
      ),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return BlocProvider(
          create: (context) => AuthenticationCubit(
              isAuthenticated: !settingsState.isAuthenticationOn)
            ..authenticate(),
          child: MaterialApp(
            title: '473252049',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsState.themeMode,
            home: BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, authState) {
                if (authState.isAuthenticated == false) {
                  return Center(
                    child: ElevatedButton(
                      child: Text('Authorize'),
                      onPressed: () {
                        context.read<AuthenticationCubit>().authenticate();
                      },
                    ),
                  );
                }
                return BlocProvider(
                  create: (context) => CategoriesCubit(
                    LocalDatabaseCategoriesRepository(),
                  )..loadCategories(),
                  child: MainPage(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
