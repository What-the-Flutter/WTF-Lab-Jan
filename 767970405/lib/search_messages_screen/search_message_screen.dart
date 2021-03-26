import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../data/theme/custom_theme.dart';

import '../messages_screen/screen_message.dart';
import '../messages_screen/screen_message_cubit.dart';
import '../settings_screen/general_options_cubit.dart';
import 'search_message_screen_cubit.dart';

class SearchMessageScreen extends StatelessWidget {
  static const routeName = '/SearchMsg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                    onPressed: context
                        .read<SearchMessageScreenCubit>()
                        .resetController)
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
          final curTheme =
              context.read<GeneralOptionsCubit>().state.currentTheme;
          if (state is SearchMessageScreenWait) {
            return HelpWindow(
              iconData: Icons.search,
              content: 'Please enter a search query to begin searching',
              theme: curTheme.helpWindowTheme,
            );
          } else if (state is SearchMessageScreenNotFound) {
            return HelpWindow(
              title: 'No search results available',
              content: 'No entries math the given'
                  ' search query. Please try again.',
              theme: curTheme.helpWindowTheme,
            );
          } else {
            final isLeftBubbleAlign =
                context.read<GeneralOptionsCubit>().state.isLeftBubbleAlign;
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return Message(
                  theme: curTheme.messageTheme,
                  index: index,
                  isSelected: state.list[index].isSelected,
                  isFavor: state.list[index].isFavor,
                  title: state.page.title,
                  photoPath: state.list[index].photo,
                  event: state.list[index].indexCategory,
                  text: state.list[index].text,
                  date: DateFormat.Hm().format(state.list[index].pubTime),
                  align: isLeftBubbleAlign
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
    return Container(
      constraints: BoxConstraints(maxWidth: 350, maxHeight: 150),
      padding: EdgeInsets.all(10),
      color: theme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min,
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
