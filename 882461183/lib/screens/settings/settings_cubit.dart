import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/theme/theme_color.dart';

part 'settings_state.dart';

enum Themes {
  light,
  dark,
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(theme: lightTheme));

  Future<void> initSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final changedTheme = prefs.getString('theme') ?? 'light';
    final finalTheme = changedTheme == 'light' ? Themes.light : Themes.dark;

    final fontSize = prefs.getDouble('fontSize') ?? 16;
    var fontSizeString = 'Medium';
    if (fontSize == 13) {
      fontSizeString = 'Small';
    } else if (fontSize == 19) {
      fontSizeString = 'Large';
    }

    final isBubbleChatLeft = prefs.getBool('bubbleChatSide') ?? true;

    final backgroundImagePath = prefs.getString('backGroundImage') ?? '';

    emit(
      state.copyWith(
        themeData: finalTheme,
        theme: changedTheme == 'light' ? lightTheme : darkTheme,
        fontSize: fontSize,
        isBubbleChatleft: isBubbleChatLeft,
        backgroundImagePath: backgroundImagePath,
        fontSizeString: fontSizeString,
      ),
    );
  }

  Future<void> changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state.themeData == Themes.light) {
      emit(state.copyWith(theme: darkTheme, themeData: Themes.dark));
      prefs.setString('theme', 'dark');
    } else {
      emit(state.copyWith(theme: lightTheme, themeData: Themes.light));
      prefs.setString('theme', 'light');
    }
  }

  Future<void> changeFontSize(String size) async {
    final prefs = await SharedPreferences.getInstance();
    switch (size) {
      case 'Small':
        emit(state.copyWith(fontSize: 13, fontSizeString: size));
        prefs.setDouble('fontSize', 13);
        break;
      case 'Medium':
        emit(state.copyWith(fontSize: 16, fontSizeString: size));
        prefs.setDouble('fontSize', 16);
        break;
      case 'Large':
        emit(state.copyWith(fontSize: 19, fontSizeString: size));
        prefs.setDouble('fontSize', 19);
        break;
    }
  }

  Future share() async {
    final subject = 'Chat Journal';
    final text =
        '''Keep track of your life with Chat Journal, a simple and
                    elegant chat-based journal/notes application that makes
                    journaling/note-taking fun, easy, quick and effortless''';
    final urlShare = Uri.encodeComponent(
        'https://play.google.com/store/apps/details?id=com.agiletelescope.chatjournal');
    await FlutterShare.share(title: subject, text: text, linkUrl: urlShare);
  }

  Future resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', 16);
    prefs.setBool('bubbleChatSide', true);
    prefs.setString('theme', 'light');
    prefs.setString('backGroundImage', '');
    emit(
      state.copyWith(
        fontSize: 16,
        fontSizeString: 'Medium',
        theme: lightTheme,
        themeData: Themes.light,
        isBubbleChatleft: true,
        backgroundImagePath: '',
      ),
    );
  }

  Future changeBubbleChatSide() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('bubbleChatSide', !state.isBubbleChatleft);
    emit(state.copyWith(isBubbleChatleft: !state.isBubbleChatleft));
  }

  Future addBGImage() async {
    final prefs = await SharedPreferences.getInstance();
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    emit(state.copyWith(backgroundImagePath: image.path));
    prefs.setString('backGroundImage', image.path);
  }

  Future resetBGImage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('backGroundImage', '');
    emit(state.copyWith(backgroundImagePath: ''));
  }
}
