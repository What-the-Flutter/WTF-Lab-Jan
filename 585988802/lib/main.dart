import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'blocs/blocs.dart';
import 'blocs/tab/tab_bloc.dart';
import 'models/suggestion.dart';
import 'preferences/theme_preferences/theme_preferences.dart';
import 'screens/home_screen.dart';
import 'theme_provider/custom_theme_provider.dart';

//Temporary list to test functionality.
List<Suggestion> suggestionsList = [];

void main() async {
  // Bloc.observer = CustomBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await initThemePreferences();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<SuggestionsBloc>(
      create: (context) => SuggestionsBloc(suggestionsList: suggestionsList),
    ),
    BlocProvider<TabBloc>(
      create: (context) => TabBloc(),
    ),
  ], child: App()));
}

///Main class of app.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: 'Chat journal',
            themeMode: themeProvider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: HomeScreen(
              title: 'Home',
            ),
          );
        },
      );
}
