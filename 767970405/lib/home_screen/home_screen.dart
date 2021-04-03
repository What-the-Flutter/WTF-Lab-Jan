import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../widgets/custom_list_tile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../data/custom_icon/my_flutter_app_icons.dart';
import '../data/model/model_page.dart';
import '../data/theme/custom_theme.dart' as my;
import '../main.dart';
import '../messages_screen/screen_message.dart';
import '../messages_screen/screen_message_cubit.dart';
import '../screen_creating_page/create_new_page.dart';
import '../screen_creating_page/screen_creating_page_cubit.dart';
import '../search_messages_screen/search_message_screen_cubit.dart';
import '../settings_screen/general_options_cubit.dart';
import '../settings_screen/settings_screen.dart';
import 'home_screen_cubit.dart';

class HomeWindow extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();

  static final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: Text('Home'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.invert_colors),
                  onPressed: () {
                    context.read<GeneralOptionsCubit>().toggleTheme();
                    saveTheme(context
                        .read<GeneralOptionsCubit>()
                        .state
                        .appBrightness
                        .index);
                  },
                ),
              ],
            ),
            drawer: _drawer(context),
            body: BlocBuilder<HomeScreenCubit, HomeScreenState>(
              builder: (context, state) => state is HomeScreenShow
                  ? ChatPreviewList()
                  : Center(child: Text('Await')),
            ),
            floatingActionButton: AddChatButton(),
            bottomNavigationBar: BlocBuilder<HomeScreenCubit, HomeScreenState>(
              builder: _bottomNavigationBar,
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    final listTileTheme = my.ListTileTheme(
      titleStyle: TextStyle(
        fontSize:
            context.read<GeneralOptionsCubit>().state.floatingWindowFontSize,
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
            onTap: () {
              // TODO
            },
            theme: listTileTheme.copyWith(leadingIconColor: Colors.cyan),
          ),
          CustomListTile(
            leadingIcon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              //TODO
            },
            theme: listTileTheme.copyWith(leadingIconColor: Colors.blue),
          ),
          CustomListTile(
            leadingIcon: Icons.stacked_line_chart,
            title: 'Statistics',
            onTap: () {
              //TODO
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
            onTap: () {},
            theme: listTileTheme.copyWith(leadingIconColor: Colors.orange),
          )
        ],
      ),
    );
  }

  Future<Null> shareScreenshot(BuildContext context) async {
    Navigator.pop(context);
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
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

  Widget _bottomNavigationBar(BuildContext context, HomeScreenState state) {
    return BottomNavigationBar(
      currentIndex: state.currentIndex,
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(
            Icons.home,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Daily',
          icon: Icon(
            Icons.event_note_sharp,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Timeline',
          icon: Icon(
            Icons.timeline,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Explore',
          icon: Icon(
            Icons.explore,
          ),
        )
      ],
      onTap: (index) => context.read<HomeScreenCubit>().changeScreen(index),
    );
  }
}

class ChatPreviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final generalOptionState = context.read<GeneralOptionsCubit>().state;
    final previewTheme = my.ChatPreviewTheme(
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: generalOptionState.titleFontSize,
        color: generalOptionState.titleColor,
      ),
      contentStyle: TextStyle(
        fontSize: generalOptionState.bodyFontSize,
        color: generalOptionState.bodyColor,
      ),
    );
    final categoryTheme = my.CategoryTheme(
      backgroundColor: generalOptionState.categoryBackgroundColor,
      iconColor: generalOptionState.categoryIconColor,
    );
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) => ListView.separated(
        itemCount: state.list.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Bot(
              theme: my.BotTheme(
                contentStyle: TextStyle(
                  fontSize: generalOptionState.bodyFontSize,
                  color: generalOptionState.titleColor,
                ),
                iconColor: generalOptionState.botIconColor,
                backgroundColor: generalOptionState.botBackgroundColor,
              ),
            );
          }
          return ChatPreview(
            index: i - 1,
            title: state.list[i - 1].title,
            subtitle: 'No events click create to one',
            isPinned: state.list[i - 1].isPinned,
            iconData: context
                .read<ScreenCreatingPageCubit>()
                .getIcon(state.list[i - 1].iconIndex),
            previewTheme: previewTheme,
            categoryTheme: categoryTheme,
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}

class Bot extends StatelessWidget {
  final my.BotTheme theme;

  const Bot({
    Key key,
    this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            MyFlutterApp.smart_toy_24px,
            size: 30,
            color: theme.iconColor,
          ),
          Text(
            'Questionnaire Bot',
            style: theme.contentStyle,
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: theme.backgroundColor,
      ),
      margin: EdgeInsetsDirectional.only(start: 30.0, top: 5.0, end: 30.0),
      width: 200,
      height: 50,
    );
  }
}

class AddChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 10.0,
      child: Icon(
        Icons.add,
      ),
      onPressed: () async {
        context.read<ScreenCreatingPageCubit>().setting('', 0);
        await Navigator.pushNamed(
          context,
          CreateNewPage.routName,
        );
        final state = context.read<ScreenCreatingPageCubit>().state;
        if (state.iconButton != Icons.close) {
          context.read<HomeScreenCubit>().addPage(
                ModelPage(
                  iconIndex: state.selectionIconIndex,
                  title:
                      context.read<ScreenCreatingPageCubit>().controller.text,
                ),
              );
        }
        context.read<ScreenCreatingPageCubit>().resetIcon();
      },
    );
  }
}

class ChatPreview extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final bool isPinned;
  final my.ChatPreviewTheme previewTheme;
  final my.CategoryTheme categoryTheme;
  final IconData iconData;

  ChatPreview({
    this.index,
    this.title,
    this.subtitle,
    this.isPinned,
    this.iconData,
    this.previewTheme,
    this.categoryTheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        context
            .read<ScreenMessageCubit>()
            .downloadData(context.read<HomeScreenCubit>().state.list[index]);
        context
            .read<SearchMessageScreenCubit>()
            .setting(page: context.read<HomeScreenCubit>().state.list[index]);
        await Navigator.pushNamed(
          context,
          ScreenMessage.routeName,
        );
      },
      onLongPress: () => _showActionMenu(context),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          ListTile(
            title: Text(
              title,
              style: previewTheme.titleStyle,
            ),
            subtitle: Text(
              subtitle,
              style: previewTheme.contentStyle,
            ),
            horizontalTitleGap: 5.0,
            contentPadding: EdgeInsets.all(5.0),
            leading: Container(
              width: 75,
              height: 75,
              child: Icon(
                iconData,
                color: categoryTheme.iconColor,
              ),
              decoration: BoxDecoration(
                color: categoryTheme.backgroundColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          isPinned ? Icon(Icons.push_pin) : Container(),
        ],
      ),
    );
  }

  void _showActionMenu(BuildContext context) {
    final homeCubit = context.read<HomeScreenCubit>();
    final screenCreatingCubit = context.read<ScreenCreatingPageCubit>();
    final listTileTheme = my.ListTileTheme(
      titleStyle: TextStyle(
        fontSize:
            context.read<GeneralOptionsCubit>().state.floatingWindowFontSize,
      ),
    );
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CustomListTile(
            leadingIcon: Icons.info,
            title: 'info',
            onTap: () => _showPreviewInfo(homeCubit, context),
            theme: listTileTheme.copyWith(leadingIconColor: Colors.teal),
          ),
          CustomListTile(
            leadingIcon: Icons.attach_file,
            title: 'Pin/Unpin Page',
            onTap: () {
              Navigator.pop(context);
              homeCubit.pinPage(index);
            },
            theme: listTileTheme.copyWith(leadingIconColor: Colors.green),
          ),
          CustomListTile(
            leadingIcon: Icons.archive,
            title: 'Archive Page',
            onTap: () {},
            theme: listTileTheme.copyWith(leadingIconColor: Colors.orange),
          ),
          CustomListTile(
            leadingIcon: Icons.edit,
            title: 'Edit page',
            onTap: () async {
              Navigator.pop(context);
              screenCreatingCubit.setting(
                homeCubit.state.list[index].title,
                homeCubit.state.list[index].iconIndex,
              );
              await Navigator.pushNamed(
                context,
                CreateNewPage.routName,
              );
              if (screenCreatingCubit.state.iconButton != Icons.close) {
                homeCubit.editPage(
                  homeCubit.state.list[index].copyWith(
                    iconIndex: screenCreatingCubit.state.selectionIconIndex,
                    title: screenCreatingCubit.controller.text,
                  ),
                );
              }
              screenCreatingCubit.resetIcon();
            },
            theme: listTileTheme.copyWith(leadingIconColor: Colors.blue),
          ),
          CustomListTile(
            leadingIcon: Icons.delete,
            title: 'Delete Page',
            onTap: () {
              Navigator.pop(context);
              context.read<HomeScreenCubit>().removePage(index);
            },
            theme: listTileTheme.copyWith(leadingIconColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showPreviewInfo(HomeScreenCubit cubit, BuildContext context) {
    Navigator.pop(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(cubit.state.list[index].title),
              leading: Container(
                width: 75,
                height: 75,
                child: Icon(
                  context
                      .read<ScreenCreatingPageCubit>()
                      .getIcon(cubit.state.list[index].iconIndex),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            ),
            ListTile(
              title: Text('Created'),
              subtitle: Text(
                cubit.state.list[index].creationTime.toString(),
              ),
            ),
            ListTile(
              title: Text('Latest Event'),
              subtitle: Text(
                cubit.state.list[index].lastModifiedTime.toString(),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Center(
              child: Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}
