import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
                        .resetController,
                  )
                : Container(),
          )
        ],
      ),
      body: _listFoundMessage(),
    );
  }

  Widget _listFoundMessage() {
    return Center(
      child: BlocBuilder<SearchMessageScreenCubit, SearchMessageScreenState>(
        builder: (context, state) {
          if (state is SearchMessageScreenWait) {
            return Container(
              padding: EdgeInsets.all(20),
              color: context
                  .read<GeneralOptionsCubit>()
                  .state
                  .currentTheme
                  .helpWindow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 55,
                  ),
                  Text('Please enter a search query to begin searching'),
                ],
              ),
            );
          } else if (state is SearchMessageScreenNotFound) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              color: context
                  .read<GeneralOptionsCubit>()
                  .state
                  .currentTheme
                  .helpWindow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'No search results available',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: Text('No entries math the given'
                        ' search query. Please try again.'),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return Message(
                  color: state.list[index].isSelected
                      ? context
                          .read<GeneralOptionsCubit>()
                          .state
                          .currentTheme
                          .selectedMsg
                      : context
                          .read<GeneralOptionsCubit>()
                          .state
                          .currentTheme
                          .unselectedMsg,
                  index: index,
                  isSelected: state.list[index].isSelected,
                  isFavor: state.list[index].isFavor,
                  title:
                      Text(context.read<ScreenMessageCubit>().state.page.title),
                  photo: state.list[index].photo != null
                      ? Image.file(File(state.list[index].photo))
                      : Container(),
                  event: state.list[index].indexCategory,
                  text: state.list[index].text != null
                      ? Text(state.list[index].text)
                      : Container(),
                  date: DateFormat.Hm().format(state.list[index].pubTime),
                  align: context
                          .read<GeneralOptionsCubit>()
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
