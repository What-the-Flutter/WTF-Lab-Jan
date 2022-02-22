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

const _themeColor = 'theme';
const _lightTheme = 'light';
const _darkTheme = 'dark';

const _fontSize = 'fontSize';
const _bubbleChatSide = 'bubbleChatSide';
const _backGroundImage = 'backGroundImage';
const _dateCenterAlign = 'dateCenterAlign';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(theme: lightTheme));

  Future<void> initSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final changedTheme = prefs.getString(_themeColor) ?? _lightTheme;
    final finalTheme = changedTheme == _lightTheme ? 0 : 1;

    final fontSize = prefs.getDouble(_fontSize) ?? 16;
    var fontSizeString = 'Medium';
    if (fontSize == 13) {
      fontSizeString = 'Small';
    } else if (fontSize == 19) {
      fontSizeString = 'Large';
    }

    final isBubbleChatLeft = prefs.getBool(_bubbleChatSide) ?? true;
    final isCenterDate = prefs.getBool(_dateCenterAlign) ?? false;

    final backgroundImagePath = prefs.getString(_backGroundImage) ?? '';

    emit(
      state.copyWith(
        themeData: finalTheme,
        theme: changedTheme == _lightTheme ? lightTheme : darkTheme,
        fontSize: fontSize,
        isBubbleChatleft: isBubbleChatLeft,
        isDateCenterAlign: isCenterDate,
        backgroundImagePath: backgroundImagePath,
        fontSizeString: fontSizeString,
      ),
    );
  }

  Future<void> changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state.themeData == 0) {
      emit(state.copyWith(theme: darkTheme, themeData: 1));
      prefs.setString(_themeColor, _darkTheme);
    } else {
      emit(state.copyWith(theme: lightTheme, themeData: 0));
      prefs.setString(_themeColor, _lightTheme);
    }
  }

  Future<void> changeFontSize(String size) async {
    final prefs = await SharedPreferences.getInstance();
    switch (size) {
      case 'Small':
        emit(state.copyWith(fontSize: 13, fontSizeString: 'Small'));
        prefs.setDouble(_fontSize, 13);
        break;
      case 'Medium':
        emit(state.copyWith(fontSize: 16, fontSizeString: 'Medium'));
        prefs.setDouble(_fontSize, 16);
        break;
      case 'Large':
        emit(state.copyWith(fontSize: 19, fontSizeString: 'Large'));
        prefs.setDouble(_fontSize, 19);
        break;
    }
  }

  Future share() async {
    final subject = 'Chat Journal';
    final text = '''Keep track of your life with Chat Journal, a simple and
                    elegant chat-based journal/notes application that makes
                    journaling/note-taking fun, easy, quick and effortless''';
    final urlShare = Uri.encodeComponent(
        'https://play.google.com/store/apps/details?id=com.agiletelescope.chatjournal');
    await FlutterShare.share(title: subject, text: text, linkUrl: urlShare);
  }

  Future resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(_fontSize, 16);
    prefs.setBool(_bubbleChatSide, true);
    prefs.setBool(_dateCenterAlign, false);
    prefs.setString(_themeColor, _lightTheme);
    prefs.setString(_backGroundImage, '');
    emit(
      state.copyWith(
        fontSize: 16,
        fontSizeString: 'Medium',
        theme: lightTheme,
        themeData: 0,
        isBubbleChatleft: true,
        backgroundImagePath: '',
      ),
    );
  }

  Future changeBubbleChatSide() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_bubbleChatSide, !state.isBubbleChatleft);
    emit(state.copyWith(isBubbleChatleft: !state.isBubbleChatleft));
  }

  Future changeDateAlign() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_dateCenterAlign, !state.isDateCenterAlign);
    emit(state.copyWith(isDateCenterAlign: !state.isDateCenterAlign));
  }

  Future addBGImage() async {
    final prefs = await SharedPreferences.getInstance();
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    emit(state.copyWith(backgroundImagePath: image.path));
    prefs.setString(_backGroundImage, image.path);
  }

  Future resetBGImage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_backGroundImage, '');
    emit(state.copyWith(backgroundImagePath: ''));
  }
}
