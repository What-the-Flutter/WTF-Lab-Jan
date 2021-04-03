import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

import '../../common_widgets/change_theme_button_widget.dart';
import '../../models/font_size_customization.dart';
import '../../theme/theme_bloc.dart';
import '../../theme/theme_event.dart';
import 'font_size_changing_dialog.dart';
import 'setting_screen_event.dart';
import 'settings_screen_bloc.dart';
import 'settings_screen_state.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingScreenBloc, SettingsScreenState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).hintColor,
          appBar: _appBar(context),
          body: _body(context),
        );
      },
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: Container(
        child: Text(
          'Settings',
          style: TextStyle(
            fontSize:
                BlocProvider.of<SettingScreenBloc>(context).state.fontSize == 0
                    ? appBarSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? appBarDefaultFontSize
                        : appBarLargeFontSize,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        alignment: Alignment.centerLeft,
      ),
      elevation: 5.0,
    );
  }

  ListView _body(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
          child: Text(
            'Visuals',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileHeaderSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileHeaderDefaultFontSize
                          : listTileHeaderLargeFontSize,
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
        Divider(
          color: Colors.black54,
          height: 0.5,
          thickness: 0.5,
          indent: 15,
          endIndent: 15,
        ),
        ListTile(
          leading: Icon(CupertinoIcons.circle_righthalf_fill),
          title: Text(
            'Theme',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileTitleSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileTitleDefaultFontSize
                          : listTileTitleLargeFontSize,
            ),
          ),
          subtitle: Text(
            'Light / Dark',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileSubtitleSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileSubtitleDefaultFontSize
                          : listTileSubtitleLargeFontSize,
            ),
          ),
          trailing: ChangeThemeButtonWidget(),
        ),
        ListTile(
          leading: Icon(Icons.text_fields),
          title: Text(
            'Font Size',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileTitleSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileTitleDefaultFontSize
                          : listTileTitleLargeFontSize,
            ),
          ),
          subtitle: Text(
            'Small / Default / Large',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileSubtitleSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileSubtitleDefaultFontSize
                          : listTileSubtitleLargeFontSize,
            ),
          ),
          onTap: () => _showChangeFontSizeDialog(context),
        ),
        Container(
          margin: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
          child: Text(
            'Chat Interface',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileHeaderSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileHeaderDefaultFontSize
                          : listTileHeaderLargeFontSize,
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
        Divider(
          color: Colors.black54,
          height: 0.5,
          thickness: 0.5,
          indent: 15,
          endIndent: 15,
        ),
        ListTile(
          leading: Icon(Icons.format_align_left),
          title: Text(
            'Bubble Alignment',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileTitleSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileTitleDefaultFontSize
                          : listTileTitleLargeFontSize,
            ),
          ),
          subtitle: Text(
            'Swap right-to-left bubble alignment',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileSubtitleSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileSubtitleDefaultFontSize
                          : listTileSubtitleLargeFontSize,
            ),
          ),
          trailing: Switch.adaptive(
            value: BlocProvider.of<SettingScreenBloc>(context)
                .state
                .isLeftBubbleAlignment,
            onChanged: (value) {
              BlocProvider.of<SettingScreenBloc>(context).add(
                ChangeBubbleAlignmentEvent(),
              );
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.date_range),
          title: Text(
            'Date-time modification',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileTitleSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileTitleDefaultFontSize
                          : listTileTitleLargeFontSize,
            ),
          ),
          subtitle: Text(
            'Allows manual date and time for an entry',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileSubtitleSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileSubtitleDefaultFontSize
                          : listTileSubtitleLargeFontSize,
            ),
          ),
          trailing: Switch.adaptive(
            value: BlocProvider.of<SettingScreenBloc>(context)
                .state
                .isDateTimeModification,
            onChanged: (value) {
              BlocProvider.of<SettingScreenBloc>(context).add(
                ChangeDateTimeModificationEvent(),
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
          child: Text(
            'Additional Settings',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileHeaderSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileHeaderDefaultFontSize
                          : listTileHeaderLargeFontSize,
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
        Divider(
          color: Colors.black54,
          height: 0.5,
          thickness: 0.5,
          indent: 15,
          endIndent: 15,
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text(
            'Sharing the app',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileTitleSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileTitleDefaultFontSize
                          : listTileTitleLargeFontSize,
            ),
          ),
          subtitle: Text(
            'Share the app with your friends',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileSubtitleSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileSubtitleDefaultFontSize
                          : listTileSubtitleLargeFontSize,
            ),
          ),
          onTap: () {
            Share.share(
                'https://drive.google.com/drive/folders/1RTSG-dxKRIXISmyNiQgsdPWOJXifI8-Z');
          },
        ),
        ListTile(
          leading: Icon(Icons.refresh),
          title: Text(
            'Reset Settings',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileTitleSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileTitleDefaultFontSize
                          : listTileTitleLargeFontSize,
            ),
          ),
          subtitle: Text(
            'After clicking on this button, return to default settings',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:
                  BlocProvider.of<SettingScreenBloc>(context).state.fontSize ==
                          0
                      ? listTileSubtitleSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? listTileSubtitleDefaultFontSize
                          : listTileSubtitleLargeFontSize,
            ),
          ),
          onTap: () {
            BlocProvider.of<SettingScreenBloc>(context).add(
              ResetSettingsEvent(),
            );
            BlocProvider.of<ThemeBloc>(context).add(
              ResetThemeEvent(),
            );
          },
        ),
      ],
    );
  }

  Future<void> _showChangeFontSizeDialog(BuildContext context) async {
    await showGeneralDialog(
      barrierDismissible: false,
      context: context,
      transitionDuration: Duration(milliseconds: 800),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeOutCubic,
          ),
          child: FontSizeChangingDialog(
            title: 'Font Size',
            firstBtnText: 'Cancel',
            icon: Icon(Icons.text_fields),
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return null;
      },
    );
  }
}
