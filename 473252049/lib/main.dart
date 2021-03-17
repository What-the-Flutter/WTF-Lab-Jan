import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/cubits/categories/categories_cubit.dart';
import 'pages/main_page.dart';
import 'repositories/local_database/local_database_categories_repository.dart';
import 'thememode_cubit/thememode_cubit.dart';

class CubitsObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print('$cubit $change');
    super.onChange(cubit, change);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = CubitsObserver();
  runApp(
    MyApp(
      preferences: await SharedPreferences.getInstance(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;

  const MyApp({Key key, @required this.preferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThememodeCubit(
        preferences: preferences,
      ),
      child: ThemingApp(),
    );
  }
}

class ThemingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThememodeCubit, ThememodeState>(
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
