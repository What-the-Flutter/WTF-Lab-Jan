import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../data/constants/constants.dart';
import '../data/theme/custom_theme.dart';
import '../home_screen/home_screen_cubit.dart';
import '../messages_screen/screen_message.dart';
import '../messages_screen/screen_message_cubit.dart';
import '../settings_screen/chat_interface_setting_cubit.dart';
import '../settings_screen/visual_setting_cubit.dart';
import '../widgets/search_item.dart';
import 'search_message_screen_cubit.dart';

class SearchMessageScreen extends StatelessWidget {
  static const routeName = '/SearchMsg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.read<SearchMessageScreenCubit>().reset();
            Navigator.pop(context);
          },
        ),
        title: TextField(
          autofocus: true,
          controller: context.read<SearchMessageScreenCubit>().controller,
          decoration: InputDecoration(
            hintText: context
                        .read<SearchMessageScreenCubit>()
                        .state
                        .modeScreen ==
                    ModeScreen.onePage
                ? 'Search in ${context.read<ScreenMessageCubit>().state.page.title}'
                : 'Search in all pages',
          ),
        ),
        actions: <Widget>[
          BlocBuilder<SearchMessageScreenCubit, SearchMessageScreenState>(
            builder: (context, state) {
              if (!context.read<SearchMessageScreenCubit>().isTextEmpty()) {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: context.read<SearchMessageScreenCubit>().reset,
                );
              } else {
                return Container();
              }
            },
          ),
        ],
        bottom: context.read<SearchMessageScreenCubit>().isNotEmptyTag()
            ? PreferredSize(
                preferredSize: Size.fromHeight(42),
                child: Container(
                  constraints: BoxConstraints(maxHeight: 42),
                  padding: EdgeInsets.all(5.0),
                  child: BlocBuilder<SearchMessageScreenCubit,
                      SearchMessageScreenState>(
                    builder: (context, state) {
                      final visualSettingState =
                          context.read<VisualSettingCubit>().state;
                      final theme = SearchItemTheme(
                        nameStyle: TextStyle(
                          fontSize: visualSettingState.bodyFontSize,
                          color: visualSettingState.titleColor,
                        ),
                        backgroundColor: Colors.red[200],
                        radius: 30,
                      );
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.tags.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: SearchItem(
                            key: ValueKey(index),
                            name: state.tags[index].name,
                            isSelected: state.tags[index].isSelected,
                            onTap: () {
                              context
                                  .read<SearchMessageScreenCubit>()
                                  .configureTagSearch(
                                    index,
                                    !state.tags[index].isSelected,
                                  );
                            },
                            theme: theme,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : null,
      ),
      body: _searchResult(),
    );
  }

  Widget _searchResult() {
    return Center(
      child: BlocBuilder<SearchMessageScreenCubit, SearchMessageScreenState>(
        builder: (context, state) {
          final visualSettingState = context.read<VisualSettingCubit>().state;
          final curTheme = HelpWindowTheme(
            backgroundColor: visualSettingState.helpWindowBackgroundColor,
            titleStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: visualSettingState.titleFontSize,
              color: visualSettingState.titleColor,
            ),
            contentStyle: TextStyle(
              fontSize: visualSettingState.bodyFontSize,
              color: visualSettingState.titleColor,
            ),
          );
          if (state.type == ResultSearch.wait) {
            return HelpWindow(
              iconData: Icons.search,
              content: 'Please enter a search query to begin searching',
              theme: curTheme,
            );
          } else if (state.type == ResultSearch.notFound) {
            return HelpWindow(
              title: 'No search results available',
              content: 'No entries math the given'
                  ' search query. Please try again.',
              theme: curTheme,
            );
          } else {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return Message(
                  theme: MessageTheme(
                    contentStyle: TextStyle(
                      fontSize: visualSettingState.bodyFontSize,
                      color: visualSettingState.titleColor,
                    ),
                    timeStyle: TextStyle(
                      fontSize: visualSettingState.bodyFontSize,
                      color: visualSettingState.bodyColor,
                    ),
                    unselectedColor: visualSettingState.messageUnselectedColor,
                    selectedColor: visualSettingState.messageSelectedColor,
                  ),
                  index: index,
                  isSelected: state.list[index].isSelected,
                  title: state.modeScreen == ModeScreen.onePage
                      ? state.page.title
                      : context
                          .read<HomeScreenCubit>()
                          .receiveTitlePage(state.list[index].pageId),
                  photoPath: state.list[index].photo,
                  isFavor: state.list[index].isFavor,
                  eventIndex: state.list[index].indexCategory,
                  text: state.list[index].text,
                  date: DateFormat.Hm().format(state.list[index].pubTime),
                  align: context
                          .read<ChatInterfaceSettingCubit>()
                          .state
                          .isLeftBubbleAlign
                      ? Alignment.topLeft
                      : Alignment.topRight,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class HelpWindow extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String content;
  final HelpWindowTheme theme;

  const HelpWindow({
    Key key,
    this.title,
    this.content,
    this.theme,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * (9 / 10),
      height: size.height * (2 / 10),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      color: theme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (iconData != null)
            Icon(
              iconData,
              size: 55,
            ),
          if (title != null)
            Center(
              child: Text(
                title,
                style: theme.titleStyle,
              ),
            ),
          Text(
            content,
            style: theme.contentStyle,
          ),
        ],
      ),
    );
  }
}
