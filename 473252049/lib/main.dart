import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication_cubit/authentication_cubit.dart';
import 'pages/authorization/authorization_page.dart';
import 'pages/category/cubit/records_cubit.dart';
import 'pages/main/main_page.dart';
import 'pages/main/tabs/home/cubit/categories_cubit.dart';
import 'pages/settings/cubit/settings_cubit.dart';
import 'repositories/local_database/local_database_categories_repository.dart';
import 'repositories/local_database/local_database_records_repository.dart';

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
            theme: ThemeData.light().copyWith(
              textTheme: settingsState.textTheme.apply(
                displayColor: Colors.black,
                bodyColor: Colors.black,
                decorationColor: Colors.black,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              textTheme: settingsState.textTheme.apply(
                displayColor: Colors.white,
                bodyColor: Colors.white,
                decorationColor: Colors.white,
              ),
            ),
            themeMode: settingsState.themeMode,
            home: BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, authState) {
                if (authState.isAuthenticated == false) {
                  return AuthorizationPage();
                }
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => CategoriesCubit(
                        categoriesRepository:
                            LocalDatabaseCategoriesRepository(),
                        recordsRepository: LocalDatabaseRecordsRepository(),
                      )..loadCategories(),
                    ),
                    BlocProvider(
                      create: (context) => RecordsCubit(
                        recordsRepository: LocalDatabaseRecordsRepository(),
                        categoriesRepository:
                            LocalDatabaseCategoriesRepository(),
                      )..loadRecords(),
                    ),
                  ],
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
