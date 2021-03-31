import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page/home_page.dart';
import 'themes/cubit_theme.dart';
import 'themes/states_theme.dart';
import 'utils/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.initialize();
  runApp(
    BlocProvider(
      create: (context) => CubitTheme(),
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
