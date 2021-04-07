import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../data/theme/custom_theme.dart';

import '../messages_screen/screen_message.dart';
import '../messages_screen/screen_message_cubit.dart';
import '../settings_screen/setting_screen_cubit.dart';
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
            }),
        title: TextField(
          autofocus: true,
          controller: context.read<SearchMessageScreenCubit>().controller,
          decoration: InputDecoration(
            labelText:
                'Search in ${context.read<ScreenMessageCubit>().state.page.title}',
          ),
        ),
        actions: <Widget>[
          BlocBuilder<SearchMessageScreenCubit, SearchMessageScreenState>(
            builder: (context, state) => state is! SearchMessageScreenWait
                ? IconButton(
                    icon: Icon(Icons.close),
                    onPressed: context.read<SearchMessageScreenCubit>().reset,
                  )
                : Container(),
          ),
        ],
      ),
      body: _searchResult(),
    );
  }

  Widget _searchResult() {
    return Center(
      child: BlocBuilder<SearchMessageScreenCubit, SearchMessageScreenState>(
        builder: (context, state) {
          final generalOptionState = context.read<SettingScreenCubit>().state;
          final curTheme = HelpWindowTheme(
            backgroundColor: generalOptionState.helpWindowBackgroundColor,
            titleStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: generalOptionState.titleFontSize,
              color: generalOptionState.titleColor,
            ),
            contentStyle: TextStyle(
              fontSize: generalOptionState.bodyFontSize,
              color: generalOptionState.titleColor,
            ),
          );
          if (state is SearchMessageScreenWait) {
            return HelpWindow(
              iconData: Icons.search,
              content: 'Please enter a search query to begin searching',
              theme: curTheme,
            );
          } else if (state is SearchMessageScreenNotFound) {
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
                      fontSize: generalOptionState.bodyFontSize,
                      color: generalOptionState.titleColor,
                    ),
                    timeStyle: TextStyle(
                      fontSize: generalOptionState.bodyFontSize,
                      color: generalOptionState.bodyColor,
                    ),
                    unselectedColor: generalOptionState.messageUnselectedColor,
                    selectedColor: generalOptionState.messageSelectedColor,
                  ),
                  index: index,
                  isSelected: state.list[index].isSelected,
                  title: state.page.title,
                  photoPath: state.list[index].photo,
                  isFavor: state.list[index].isFavor,
                  eventIndex: state.list[index].indexCategory,
                  text: state.list[index].text,
                  date: DateFormat.Hm().format(state.list[index].pubTime),
                  align: generalOptionState.isLeftBubbleAlign
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
