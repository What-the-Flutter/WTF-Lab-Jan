import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/themes.dart';
import '../pages/category_notes/category_notes_page.dart';
import '../pages/home/home_page.dart';
import '../pages/new_category/new_category_page.dart';
import '../pages/starred_notes/starred_notes_page.dart';
import 'bloc/bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        preferencesProvider: RepositoryProvider.of(context),
      )..add(const InitStateEvent()),
      child: BlocBuilder<AppBloc, AppState>(builder: (_, state) {
        return MaterialApp(
          title: 'Cool Notes',
          theme: state.theme,
          home: const HomePage(),
          onGenerateRoute: (settings) {
            Route pageRoute(Widget destination) => MaterialPageRoute(builder: (_) => destination);
            switch (settings.name) {
              case CategoryNotesPage.routeName:
                final args = settings.arguments as CategoryNotesArguments;
                return pageRoute(
                  CategoryNotesPage(category: args.category),
                );
              case StarredNotesPage.routeName:
                final args = settings.arguments as StarredNotesArguments;
                return pageRoute(
                  StarredNotesPage(
                    category: args.category,
                  ),
                );
              case NewCategoryPage.routeName:
                final args = settings.arguments as NewCategoryArguments?;
                return pageRoute(NewCategoryPage(editCategory: args?.category));
            }
          },
        );
      }),
    );
  }
}
