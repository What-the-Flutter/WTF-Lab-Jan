import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import '../data/model/search_item_data.dart';
import '../data/theme/custom_theme.dart' as my;
import '../filter_screen/filter_screen_cubit.dart';
import '../settings_screen/setting_screen.dart';
import '../settings_screen/visual_setting_cubit.dart';
import '../statistic_screen/statistic_cubit.dart';
import '../statistic_screen/statistic_screen.dart';
import 'custom_list_tile.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final listTileTheme = my.ListTileTheme(
      titleStyle: TextStyle(
        fontSize:
            context.read<VisualSettingCubit>().state.floatingWindowFontSize,
      ),
    );
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
          ),
          CustomListTile(
            leadingIcon: Icons.card_giftcard,
            title: 'Help spread the word',
            onTap: () => shareScreenshot(context),
            theme: listTileTheme.copyWith(leadingIconColor: Colors.yellow),
          ),
          CustomListTile(
            leadingIcon: Icons.search,
            title: 'Search',
            onTap: () => Navigator.pop(context),
            theme: listTileTheme.copyWith(leadingIconColor: Colors.cyan),
          ),
          CustomListTile(
            leadingIcon: Icons.notifications,
            title: 'Notifications',
            onTap: () => Navigator.pop(context),
            theme: listTileTheme.copyWith(leadingIconColor: Colors.blue),
          ),
          CustomListTile(
            leadingIcon: Icons.stacked_line_chart,
            title: 'Statistics',
            onTap: () {
              context.read<FilterScreenCubit>().updatePages();
              context
                  .read<StatisticCubit>()
                  .updateStatistic(<SearchItemData>[]);
              Navigator.pop(context);
              Navigator.pushNamed(context, StatisticScreen.routeName);
            },
            theme: listTileTheme.copyWith(leadingIconColor: Colors.red),
          ),
          CustomListTile(
            leadingIcon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                SettingsScreen.routeName,
              );
            },
            theme: listTileTheme.copyWith(leadingIconColor: Colors.brown),
          ),
          CustomListTile(
            leadingIcon: Icons.feedback,
            title: 'Feedback',
            onTap: () => Navigator.pop(context),
            theme: listTileTheme.copyWith(leadingIconColor: Colors.orange),
          )
        ],
      ),
    );
  }

  Future<Null> shareScreenshot(BuildContext context) async {
    Navigator.pop(context);
    try {
      RenderRepaintBoundary boundary = context.findRenderObject();
      if (boundary.debugNeedsPaint) {
        Timer(Duration(seconds: 1), () => shareScreenshot(context));
        return null;
      }
      var image = await boundary.toImage();
      final directory = (await getExternalStorageDirectory()).path;
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var imgFile = File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      final RenderBox box = context.findRenderObject();
      Share.shareFiles(['$directory/screenshot.png'],
          subject: 'Share ScreenShot',
          text: 'Hello, check your share files!',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } on PlatformException catch (e) {
      print('Exception while taking screenshot:$e');
    }
  }
}
