import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/create_category/create_category_page.dart';
import '../pages/home/home_page.dart';
import '../pages/note/notes_page.dart';
import 'data/repositories/category_repository.dart';
import 'data/repositories/db/db_provider.dart';
import 'data/repositories/note_repository.dart';
import 'logic/debug/bloc_observer.dart';
import 'utils/theme.dart';

void main() async {
  Bloc.observer = BlocObs();
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>(
          create: (_) => CategoryRepository(DbProvider.dbProvider),
        ),
        RepositoryProvider<NoteRepository>(
            create: (_) => NoteRepository(DbProvider.dbProvider)),
      ],
      child: ChangeNotifierProvider(
        child: const App(),
        create: (context) =>
            ThemeProvider(isDarkMode: prefs.getBool('isDarkTheme') as bool),
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        title: 'Sticky Notes',
        theme: themeProvider.getTheme,
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        onGenerateRoute: (settings) {
          Route pageRoute(Widget destination) =>
              MaterialPageRoute(builder: (_) => destination);
          switch (settings.name) {
            case HomePage.routeName:
              return pageRoute(HomePage());
            case NotesPage.routeName:
              final args = settings.arguments as NotesArguments;
              return pageRoute(
                NotesPage(category: args.category),
              );
            case NewCategoryPage.routeName:
              final args = settings.arguments as NewCategoryArguments?;
              return pageRoute(NewCategoryPage(editCategory: args?.category));
          }
        },
      );
    });
  }
}
