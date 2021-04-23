import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../data/constants/constants.dart';
import '../data/custom_icon/my_flutter_app_icons.dart';
import '../data/model/model_page.dart';
import '../data/theme/custom_theme.dart' as my;
import '../messages_screen/screen_message.dart';
import '../messages_screen/screen_message_cubit.dart';
import '../screen_creating_page/create_new_page.dart';
import '../screen_creating_page/screen_creating_page_cubit.dart';
import '../search_messages_screen/search_message_screen_cubit.dart';
import '../settings_screen/visual_setting_cubit.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/drawer.dart';
import '../widgets/my_bottom_navigation_bar.dart';
import 'home_screen_cubit.dart';

class HomeWindow extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();
  final MyBottomNavigationBar bottomNavigationBar;
  final MyDrawer drawer;

  HomeWindow({
    this.drawer,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.invert_colors),
              onPressed: () {
                final cubit = context.read<VisualSettingCubit>();
                cubit.toggleTheme();
                cubit.saveVisualSettings(
                  'theme',
                  cubit.state.appBrightness.index,
                );
              },
            ),
          ],
        ),
        drawer: drawer,
        body: BlocBuilder<HomeScreenCubit, HomeScreenState>(
          builder: (context, state) {
            if (state.isLoad) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Stack(
                alignment: AlignmentDirectional.topEnd,
                children: <Widget>[
                  ChatPreviewList(),
                  Positioned(
                    top: MediaQuery.of(context).size.height * (1 / 10),
                    right: MediaQuery.of(context).size.height * (1 / 100),
                    child: Bot(
                      theme: my.BotTheme(
                        contentStyle: TextStyle(
                          fontSize: context
                              .read<VisualSettingCubit>()
                              .state
                              .bodyFontSize,
                          color: context
                              .read<VisualSettingCubit>()
                              .state
                              .titleColor,
                        ),
                        iconColor: context
                            .read<VisualSettingCubit>()
                            .state
                            .botIconColor,
                        backgroundColor: context
                            .read<VisualSettingCubit>()
                            .state
                            .botBackgroundColor,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        floatingActionButton: AddChatButton(),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

class ChatPreviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final visualSettingState = context.read<VisualSettingCubit>().state;
    final previewTheme = my.ChatPreviewTheme(
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: visualSettingState.titleFontSize,
        color: visualSettingState.titleColor,
      ),
      contentStyle: TextStyle(
        fontSize: visualSettingState.bodyFontSize,
        color: visualSettingState.bodyColor,
      ),
    );
    final categoryTheme = my.CategoryTheme(
      backgroundColor: visualSettingState.categoryBackgroundColor,
      iconColor: visualSettingState.categoryIconColor,
    );
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.pages.length,
          itemBuilder: (context, i) {
            return ChatPreview(
              index: i,
              title: state.pages[i].title,
              subtitle: 'No events click create to one',
              isPinned: state.pages[i].isPinned,
              iconData: context.read<ScreenCreatingPageCubit>().getIcon(
                    state.pages[i].iconIndex,
                  ),
              previewTheme: previewTheme,
              categoryTheme: categoryTheme,
            );
          },
        );
      },
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
      padding: EdgeInsets.all(10.0),
      child: Icon(
        MyFlutterApp.smart_toy_24px,
        size: 50,
        color: theme.iconColor,
      ),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

class AddChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'HomeTag',
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
      onTap: () {
        context.read<ScreenMessageCubit>().downloadMsg(
              context.read<HomeScreenCubit>().state.pages[index],
            );
        context.read<SearchMessageScreenCubit>().setting(
              mode: ModeScreen.onePage,
              tags: context.read<ScreenMessageCubit>().state.tags,
              page: context.read<HomeScreenCubit>().state.pages[index],
            );
        Navigator.pushNamed(
          context,
          ScreenMessage.routeName,
          arguments: context,
        );
      },
      onLongPress: () => _showActionMenu(context),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            elevation: 10.0,
            child: ListTile(
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
        fontWeight: FontWeight.normal,
        fontSize:
            context.read<VisualSettingCubit>().state.floatingWindowFontSize,
      ),
    );
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CustomListTile(
              leadingIcon: Icons.info,
              title: 'info',
              onTap: () => _showPreviewInfo(homeCubit, context),
              theme: listTileTheme.copyWith(
                leadingIconColor: Colors.teal,
              ),
            ),
            CustomListTile(
              leadingIcon: Icons.attach_file,
              title: 'Pin/Unpin Page',
              onTap: () {
                Navigator.pop(context);
                homeCubit.pinPage(index);
              },
              theme: listTileTheme.copyWith(
                leadingIconColor: Colors.green,
              ),
            ),
            CustomListTile(
              leadingIcon: Icons.archive,
              title: 'Archive Page',
              onTap: () => Navigator.pop(context),
              theme: listTileTheme.copyWith(
                leadingIconColor: Colors.orange,
              ),
            ),
            CustomListTile(
              leadingIcon: Icons.edit,
              title: 'Edit page',
              onTap: () async {
                Navigator.pop(context);
                screenCreatingCubit.setting(
                  homeCubit.state.pages[index].title,
                  homeCubit.state.pages[index].iconIndex,
                );
                await Navigator.pushNamed(
                  context,
                  CreateNewPage.routName,
                );
                if (screenCreatingCubit.state.iconButton != Icons.close) {
                  homeCubit.editPage(
                    homeCubit.state.pages[index].copyWith(
                      iconIndex: screenCreatingCubit.state.selectionIconIndex,
                      title: screenCreatingCubit.controller.text,
                    ),
                  );
                }
                screenCreatingCubit.resetIcon();
              },
              theme: listTileTheme.copyWith(
                leadingIconColor: Colors.blue,
              ),
            ),
            CustomListTile(
              leadingIcon: Icons.delete,
              title: 'Delete Page',
              onTap: () {
                Navigator.pop(context);
                context.read<HomeScreenCubit>().removePage(index);
              },
              theme: listTileTheme.copyWith(
                leadingIconColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPreviewInfo(HomeScreenCubit cubit, BuildContext context) {
    Navigator.pop(context);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(cubit.state.pages[index].title),
                leading: Container(
                  width: 75,
                  height: 75,
                  child: Icon(
                    context.read<ScreenCreatingPageCubit>().getIcon(
                          cubit.state.pages[index].iconIndex,
                        ),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              ListTile(
                title: Text('Created'),
                subtitle: Text(
                  cubit.state.pages[index].creationTime.toString(),
                ),
              ),
              ListTile(
                title: Text('Latest Event'),
                subtitle: Text(
                  cubit.state.pages[index].lastModifiedTime.toString(),
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
        );
      },
    );
  }
}
