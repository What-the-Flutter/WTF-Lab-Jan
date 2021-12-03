import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_journal/presentation/res/theme_cubit.dart';

import '../navigator/router.dart';
import '../res/styles.dart';
import 'create/cubit/create_page_cubit.dart';
import 'home/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        //BlocProvider<HomePageCubit>(create: (_) => HomePageCubit()),
        BlocProvider<CreatePageCubit>(create: (_) => CreatePageCubit()),
        //BlocProvider<EventPageCubit>(create: (_) => EventPageCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, state){
          return MaterialApp(
            title: 'MyChatJournal',
            theme: state,
            home: const HomeScreen(),
            routes: routes,
            initialRoute: Routs.home,
            onGenerateRoute: generateRoute,
          );
        },
      ),
    );
  }
}
