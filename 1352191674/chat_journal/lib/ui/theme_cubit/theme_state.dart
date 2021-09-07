part of 'theme_cubit.dart';

class ThemeState {
  final bool isLight;
  final ThemeData theme;
  final TextTheme textTheme;

  ThemeState(this.isLight, this.theme, this.textTheme);

  ThemeState copyWith({
    bool? isLight,
    ThemeData? theme,
    TextTheme? textTheme,
  }) {
    return ThemeState(
      isLight ?? this.isLight,
      theme ?? this.theme,
      textTheme ?? this.textTheme,
    );
  }

  ThemeState get lightTheme {
    return ThemeState(
      isLight,
      ThemeData(
        primaryColor: Colors.blueGrey,
        brightness: Brightness.light,
        textTheme: textTheme,
      ),
      textTheme,
    );
  }

  ThemeState get darkTheme {
    return ThemeState(
      isLight,
      ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        textTheme: textTheme,
      ),
      textTheme,
    );
  }

  static const TextTheme largeTextTheme = TextTheme(
    subtitle1: TextStyle(
      fontSize: 17,
    ),
    bodyText2: TextStyle(
      fontSize: 15,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
    ),
  );

  static const TextTheme defaultTextTheme = TextTheme(
    subtitle1: TextStyle(
      fontSize: 12,
    ),
    bodyText2: TextStyle(
      fontSize: 10,
    ),
    bodyText1: TextStyle(
      fontSize: 11,
    ),
  );

  static const TextTheme smallTextTheme = TextTheme(
    subtitle1: TextStyle(
      fontSize: 10,
    ),
    bodyText2: TextStyle(
      fontSize: 8,
    ),
    bodyText1: TextStyle(
      fontSize: 9,
    ),
  );
}
