import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_page/cubit_create_page.dart';
import 'event_page/cubit_event_page.dart';
import 'home_page/cubit_home_page.dart';
import 'home_page/home_page.dart';
import 'settings/cubit_general_settings_page.dart';
import 'themes/cubit_theme.dart';
import 'themes/states_theme.dart';
import 'timeline_page/cubit_timeline_page.dart';
import 'utils/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.initialize();
  runApp(
    MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<CubitTheme>(
          create: (context) => CubitTheme(),
        ),
        BlocProvider<CubitHomePage>(
          create: (context) => CubitHomePage(),
        ),
        BlocProvider<CubitEventPage>(
          create: (context) => CubitEventPage(),
        ),
        BlocProvider<CubitCreatePage>(
          create: (context) => CubitCreatePage(),
        ),
        BlocProvider<CubitGeneralSettings>(
          create: (context) => CubitGeneralSettings(),
        ),
        BlocProvider<CubitTimelinePage>(
          create: (context) => CubitTimelinePage(),
        ),
      ],
      child: ChatJournal(),
    ),
  );
}

class ChatJournal extends StatefulWidget {
  @override
  _ChatJournalState createState() => _ChatJournalState();
}

class _ChatJournalState extends State<ChatJournal> {
  final _appTitle = 'Chat Journal';

  @override
  void initState() {
    BlocProvider.of<CubitTheme>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitTheme, StatesTheme>(
      builder: (context, state) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: _appTitle,
        theme: state.themeData,
        home: HomePage(),
      ),
    );
  }
}
