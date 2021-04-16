import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../data/constants/constants.dart';
import '../data/theme/custom_theme.dart';
import '../filter_screen/filter_screen.dart';
import '../filter_screen/filter_screen_cubit.dart';
import '../home_screen/home_screen_cubit.dart';
import '../messages_screen/screen_message.dart';
import '../search_messages_screen/search_message_screen.dart';
import '../search_messages_screen/search_message_screen_cubit.dart';
import '../settings_screen/chat_interface_setting_cubit.dart';
import '../settings_screen/visual_setting_cubit.dart';
import '../widgets/my_bottom_navigation_bar.dart';
import 'timeline_screen_cubit.dart';

class TimelineScreen extends StatelessWidget {
  static const routeName = '/TimelineScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await context
                  .read<SearchMessageScreenCubit>()
                  .setting(ModeScreen.allPages);
              Navigator.pushNamed(
                context,
                SearchMessageScreen.routeName,
              );
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              context.read<TimelineScreenCubit>().changeDisplayList();
            },
            icon: Icon(Icons.bookmark_border),
          ),
        ],
      ),
      body: BlocBuilder<TimelineScreenCubit, TimelineScreenState>(
        builder: (context, state) => state.modeFilter == ModeFilter.complete
            ? ListView(
                reverse: true,
                children: _generateChatElementsList(context, state),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_list),
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            FilterScreen.routeName,
          );
          final state = context.read<FilterScreenCubit>().state;
          context.read<TimelineScreenCubit>().configureList(
                selectedPages:
                    state.pages.where((element) => element.isSelected).toList(),
                selectedTags:
                    state.tags.where((element) => element.isSelected).toList(),
                selectedLabel: state.labels
                    .where((element) => element.isSelected)
                    .toList(),
              );
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) => MyBottomNavigationBar(
          currentIndex: state.currentIndex,
        ),
      ),
    );
  }

  List<Widget> _generateChatElementsList(
    BuildContext context,
    TimelineScreenState state,
  ) {
    var list = <Widget>[];
    var index = state.list.length - 1;
    var filterList = context.read<TimelineScreenCubit>().groupMsgByDate;
    final visualSettingState = context.read<VisualSettingCubit>().state;
    final messageTheme = MessageTheme(
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
    );
    final dateLabelTheme = LabelDateTheme(
      backgroundColor: visualSettingState.labelDateBackgroundColor,
      dateStyle: TextStyle(
        fontSize: visualSettingState.bodyFontSize,
        color: visualSettingState.bodyColor,
      ),
    );
    for (var i = filterList.length - 1; i > -1; i--) {
      var flag = false;
      for (var j = 0; j < filterList[i].length; j++) {
        if (state.isBookmark && !state.list[index].isFavor) {
          list.add(Container());
          index--;
          continue;
        }
        flag = true;
        list.add(
          Message(
            index: index,
            isSelected: state.list[index].isSelected,
            photoPath: state.list[index].photo,
            eventIndex: state.list[index].indexCategory,
            isFavor: state.list[index].isFavor,
            text: state.list[index].text,
            date: DateFormat.Hm().format(state.list[index].pubTime),
            align: context
                    .read<ChatInterfaceSettingCubit>()
                    .state
                    .isLeftBubbleAlign
                ? Alignment.topRight
                : Alignment.topLeft,
            theme: messageTheme,
          ),
        );
        index--;
      }
      if (state.isBookmark && !flag) {
        list.add(Container());
        index--;
        continue;
      }
      list.add(
        DateLabel(
          theme: dateLabelTheme,
          date: DateFormat.yMMMd().format(
            filterList[i][0].pubTime,
          ),
          alignment:
              context.read<ChatInterfaceSettingCubit>().state.isCenterDateBubble
                  ? Alignment.center
                  : Alignment.topLeft,
        ),
      );
    }
    return list;
  }
}
