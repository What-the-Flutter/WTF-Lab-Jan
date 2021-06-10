import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bloc_observer.dart';
import 'models/theme.dart';
import 'pages/create_category/create_category_cubit.dart';
import 'pages/home/home.dart';
import 'pages/home/home_cubit.dart';
import 'repository/home_repositore.dart';
import 'repository/icons_repository.dart';
import 'services/databases/db_category.dart';
import 'services/databases/db_chat.dart';
import 'services/shared_prefs.dart';
import 'settings.dart';
import 'theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await DBCategory.init();
  await DBChat.init();
  await MySharedPreferences.sharedPrefs.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CreateCategoryCubit(IconsRepository())),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => HomeCubit(HomeRepository())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Chat Journal',
          debugShowCheckedModeBanner: false,
          theme: state.themes.themeData,
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SvgPicture.asset(
          'assets/img/Frame 11.svg',
          alignment: Alignment.bottomCenter,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: IconButton(
          icon: SvgPicture.asset('assets/img/Hamburger.svg'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Settings()),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: IconButton(
            icon: Image.asset('assets/img/Ellipse 2.png'),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
