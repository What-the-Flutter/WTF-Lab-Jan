import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/themes.dart';
import '../../utils/utils.dart';
import '../pages/category_notes/category_notes_page.dart';
import '../pages/home/home_page.dart';
import '../pages/lock/lock_page.dart';
import '../pages/new_category/new_category_page.dart';
import '../pages/settings/bloc/bloc.dart';
import '../pages/settings/settings_page.dart';
import '../pages/starred_notes/starred_notes_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(
        preferencesProvider: RepositoryProvider.of(context),
        initialState: const InitialSettingsState(),
      )..add(const InitSettingsEvent()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previousState, state) {
          var shouldRebuild = false;
          if (previousState is MainSettingsState && state is MainSettingsState) {
            shouldRebuild = previousState.isDarkMode != state.isDarkMode ||
                previousState.fontSize != state.fontSize;
          }
          return previousState.runtimeType != state.runtimeType || shouldRebuild;
        },
        builder: (_, state) {
          if (state is InitialSettingsState) {
            return Container(color: lightTheme().primaryColor);
          }
          state as MainSettingsState;
          return MaterialApp(
            title: 'Cool Notes',
            theme: state.isDarkMode
                ? darkTheme(fontSizeRatio: state.fontSize.fontRatio())
                : lightTheme(fontSizeRatio: state.fontSize.fontRatio()),
            home: state.showBiometricsDialog ? const LockPage() : const HomePage(),
            onGenerateRoute: (settings) {
              Route pageRoute(Widget destination) => MaterialPageRoute(builder: (_) => destination);
              switch (settings.name) {
                case HomePage.routeName:
                  return pageRoute(const HomePage());
                case SettingsPage.routeName:
                  return pageRoute(const SettingsPage());
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
        },
      ),
    );
  }
}
