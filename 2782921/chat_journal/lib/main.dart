import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/database_file.dart';
import 'data/preferences.dart';
import 'home_screen/home_cubit.dart';
import 'home_screen/home_page.dart';
import 'navigation/fluro_router.dart';
import 'theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseFile.initialize();
  await PreferenceData.initialize();
  FluroRouterCubit.setupRouter();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      BlocProvider<FluroRouterCubit>(create: (_) => FluroRouterCubit()),
      BlocProvider<HomeCubit>(create: (context) => HomeCubit([])),
    ], child: MyPage());
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ThemeCubit>(context).initialize();

    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, state) {
        return MaterialApp(
          home: const MyHomePage(
            title: 'Chat Journal',
          ),
          theme: state,
        );
      },
    );
  }
}
