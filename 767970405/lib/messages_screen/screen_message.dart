import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/model/model_message.dart';
import '../data/theme/custom_theme.dart';
import '../home_screen/home_screen_cubit.dart';
import '../search_messages_screen/search_message_screen.dart';
import '../settings_screen/general_options_cubit.dart';
import 'date_time_mod_button_cubit.dart';
import 'screen_message_cubit.dart';

class ScreenMessage extends StatefulWidget {
  static const routeName = '/ScreenMsg';

  @override
  _ScreenMessageState createState() => _ScreenMessageState();
}

class _ScreenMessageState extends State<ScreenMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
          builder: (context, state) {
            switch (state.mode) {
              case Mode.await:
                return AppBar(title: Text(''));
              case Mode.input:
                return InputAppBar(title: state.page.title);
              case Mode.selection:
                return SelectionAppBar();
              case Mode.edit:
                return EditAppBar(title: 'Edit mode');
              default:
                return null;
            }
          },
        ),
        preferredSize: Size.fromHeight(56),
      ),
      body: BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
        builder: (context, state) {
          if (state.mode != Mode.await) {
            return body;
          } else {
            return Center(
              child: Text('Await'),
            );
          }
        },
      ),
    );
  }

  Widget get body => Column(
    children: <Widget>[
      Expanded(
        child: BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
          builder: (context, state) {
            final state = context.read<GeneralOptionsCubit>().state;
            return ChatElementList(
              alignment: state.isLeftBubbleAlign
                  ? Alignment.topLeft
                  : Alignment.topRight,
              isDateTimeModEnabled: state.isDateTimeModification,
            );
          },
        ),
      ),
      InputPanel(),
    ],
  );


}

class ChatElementList extends StatelessWidget {
  final AlignmentGeometry alignment;
  final bool isDateTimeModEnabled;

  const ChatElementList({
    Key key,
    this.alignment,
    this.isDateTimeModEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      children: <Widget>[
        ListView(
          reverse: true,
          children: _generateChatElementsList(
              context, context.read<ScreenMessageCubit>().state),
        ),
        if (isDateTimeModEnabled)
          BlocBuilder<DateTimeModButtonCubit, DateTimeModButtonState>(
            builder: (context, state) => DateTimeModButton(
              date: DateFormat.yMMMEd().format(state.fromDate),
              theme: context
                  .read<GeneralOptionsCubit>()
                  .state
                  .currentTheme
                  .dateTimeModButtonTheme,
            ),
          ),
      ],
    );
  }

  List<Widget> _generateChatElementsList(
    BuildContext context,
    ScreenMessageState state,
  ) {
    var list = <Widget>[];
    var index = state.list.length - 1;
    var filterList = context.read<ScreenMessageCubit>().groupMsgByDate;
    final currentTheme = context.read<GeneralOptionsCubit>().state.currentTheme;
    for (var i = filterList.length - 1; i > -1; i--) {
      for (var j = 0; j < filterList[i].length; j++) {
        if (state.isBookmark && !state.list[index].isFavor) {
          list.add(Container());
          index--;
          continue;
        }
        list.add(
          Message(
            index: index,
            isSelected: state.list[index].isSelected,
            isFavor: state.list[index].isFavor,
            photoPath: state.list[index].photo,
            event: state.list[index].indexCategory,
            text: state.list[index].text,
            date: DateFormat.Hm().format(state.list[index].pubTime),
            align: context.read<GeneralOptionsCubit>().state.isLeftBubbleAlign
                ? Alignment.topLeft
                : Alignment.topRight,
            onTap: state.mode == Mode.selection
                ? context.read<ScreenMessageCubit>().selection
                : null,
            onLongPress: context.read<ScreenMessageCubit>().selection,
            theme: currentTheme.messageTheme,
          ),
        );
        index--;
      }
      list.add(
        DateLabel(
          theme: currentTheme.labelDateTheme,
          date: DateFormat.yMMMd().format(
            filterList[i][0].pubTime,
          ),
          alignment: context.read<GeneralOptionsCubit>().state.isCenterDateBubble
              ? Alignment.center
              : Alignment.topLeft,
        ),
      );
    }
    return list;
  }
}

class DateTimeModButton extends StatelessWidget {
  final String date;
  final DateTimeModButtonTheme theme;

  const DateTimeModButton({
    Key key,
    this.date,
    this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<DateTimeModButtonCubit>().state;
    return GestureDetector(
      onTap: () => selectDateAndTime(context, state),
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Icon(
                Icons.calendar_today,
                size: 16.0,
                color: theme.iconColor,
              ),
            ),
            Text(
              date,
              style: theme.dateStyle,
            ),
            if (state.isReset)
              IconButton(
                onPressed: context.read<DateTimeModButtonCubit>().reset,
                icon: Icon(
                  Icons.close,
                  size: 16.0,
                ),
              ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: theme.backgroundColor,
        ),
      ),
    );
  }

  Future<void> selectDateAndTime(
      BuildContext context, DateTimeModButtonState state) async {
    final datePicked = await _showDatePicker(context, state.fromDate);

    final timePicked = await _showTimePicker(context, state.fromTime);
    context
        .read<DateTimeModButtonCubit>()
        .updateDateAndTime(date: datePicked, time: timePicked);
  }

  Future<TimeOfDay> _showTimePicker(
      BuildContext context, TimeOfDay initialTime) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
  }

  Future<DateTime> _showDatePicker(
      BuildContext context, DateTime initialDate) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2100),
    );
  }
}

class DateLabel extends StatelessWidget {
  final String date;
  final AlignmentGeometry alignment;
  final LabelDateTheme theme;

  DateLabel({
    Key key,
    this.alignment,
    this.date,
    this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment: alignment,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: theme.backgroundColor,
          ),
          padding: EdgeInsets.all(10.0),
          child: Text(
            date,
            style: theme.dateStyle,
          ),
        ),
      ),
    );
  }
}

class InputPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.bubble_chart),
                onPressed: null,
              ),
            ),
            Expanded(
              flex: 5,
              child: TextField(
                autofocus: true,
                enabled: state.enabledController,
                controller: context.read<ScreenMessageCubit>().controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(state.iconData),
                onPressed: () => state.onAddMessage(
                  context.read<DateTimeModButtonCubit>().state.isReset
                      ? context
                          .read<DateTimeModButtonCubit>()
                          .state
                          .fromDate
                          .applied(context.read<DateTimeModButtonCubit>().state.fromTime)
                      : DateTime.now(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputAppBar extends StatelessWidget {
  final String title;

  const InputAppBar({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScreenMessageCubit, ScreenMessageState>(
      listener: (context, state) =>
          context.read<ScreenMessageCubit>().toSelectionAppBar(),
      listenWhen: (prevState, curState) =>
          prevState.counter == 0 && curState.counter == 1 ? true : false,
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Navigator.pushNamed(
                context,
                SearchMessageScreen.routeName,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: IconButton(
              icon: BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
                builder: (context, state) =>
                    context.read<ScreenMessageCubit>().state.isBookmark
                        ? Icon(
                            Icons.bookmark,
                            color: Colors.amberAccent,
                          )
                        : Icon(
                            Icons.bookmark_border,
                          ),
              ),
              onPressed: context.read<ScreenMessageCubit>().showBookmarkMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class SelectionAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ScreenMessageCubit, ScreenMessageState>(
      listener: (context, state) =>
          context.read<ScreenMessageCubit>().toInputAppBar(),
      listenWhen: (prevState, curState) =>
          prevState.counter >= 1 && curState.counter == 0 ? true : false,
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: context.read<ScreenMessageCubit>().backToInputAppBar,
        ),
        title: BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
          builder: (context, state) => Text(
            state.counter.toString(),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.share),
              onPressed: () => createDialog(context),
            ),
          ),
          BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
            builder: (context, state) => state.counter == 1
                ? Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed:
                          context.read<ScreenMessageCubit>().toEditAppBar,
                    ),
                  )
                : Container(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.copy),
              onPressed: context.read<ScreenMessageCubit>().copy,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.bookmark_border),
              onPressed: context.read<ScreenMessageCubit>().makeFavor,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: context.read<ScreenMessageCubit>().delete,
            ),
          ),
        ],
      ),
    );
  }

  void createDialog(BuildContext context) async {
    var index = 0;
    var list = await context.read<HomeScreenCubit>().repository.pages();
    list = list
        .where((element) =>
            element.id != context.read<ScreenMessageCubit>().state.page.id)
        .toList();
    showDialog(
      context: context,
      builder: (alertContext) => AlertDialog(
        content: StatefulBuilder(
          builder: (context, setState) => Container(
            height: 200,
            width: 100,
            child: ListView(
              children: <Widget>[
                for (var i = 0; i < list.length; i++)
                  RadioListTile<int>(
                    title: Text(list[i].title),
                    value: i,
                    groupValue: index,
                    onChanged: (value) => setState(() => index = value),
                  ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Center(
                    child: Text('Cancel'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: OutlinedButton(
                  onPressed: () {
                    context
                        .read<ScreenMessageCubit>()
                        .listSelected(list[index].id);
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text('Move'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditAppBar extends StatelessWidget {
  final String title;

  const EditAppBar({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.keyboard_backspace),
        onPressed: context.read<ScreenMessageCubit>().backToInputAppBar,
      ),
      title: Center(
        child: Text(title),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: context.read<ScreenMessageCubit>().backToInputAppBar,
          ),
        ),
      ],
    );
  }
}

class Message extends StatelessWidget {
  final int index;
  final bool isSelected;
  final bool isFavor;
  final String title;
  final String photoPath;
  final int event;
  final String text;
  final String date;
  final AlignmentGeometry align;
  final Function onTap;
  final Function onLongPress;
  final MessageTheme theme;

  const Message({
    Key key,
    this.index,
    this.isSelected,
    this.isFavor,
    this.title,
    this.photoPath,
    this.event,
    this.text,
    this.date,
    this.align,
    this.onTap,
    this.onLongPress,
    this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment: align,
        child: GestureDetector(
          onTap: onTap != null ? () => onTap(index) : onTap,
          onLongPress:
              onLongPress != null ? () => onLongPress(index) : onLongPress,
          child: Container(
            constraints: BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: isSelected ? theme.selectedColor : theme.unselectedColor,
            ),
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (title != null) Text(title),
                if (photoPath != null) Image.file(File(photoPath)),
                if (event != null) Container(),
                if (text != null) Text(text, style: theme.contentStyle),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      date,
                      style: theme.timeStyle,
                    ),
                    if (isFavor)
                      Icon(
                        Icons.bookmark,
                        color: Colors.orangeAccent,
                        size: 8,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
