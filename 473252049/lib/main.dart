import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      builder: (context, state) {
        return MaterialApp(
          title: '473252049',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: state.themeMode,
          home: BlocProvider(
            create: (context) => CategoriesCubit(
              LocalDatabaseCategoriesRepository(),
            )..loadCategories(),
            child: MainPage(),
          ),
        );
      },
    );
  }
}
