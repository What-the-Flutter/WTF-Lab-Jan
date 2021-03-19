import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:try_bloc_app/pages/settings/setting_page_cubit.dart';

import '../../enums/enums.dart';
import '../../repository/category_repository.dart';
import '../../theme/theme_model.dart';
import '../home/home_screen_cubit.dart';
import '../search/searching_message.dart';
import 'screen_messages_cubit.dart';

bool isVisibleCategories = false;
Operation currentOperation = Operation.input;

class ScreenMessages extends StatefulWidget {
  static const routeName = '/ScreenMsg';

  @override
  _ScreenMessagesState createState() => _ScreenMessagesState();
}

class _ScreenMessagesState extends State<ScreenMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: BlocBuilder<ScreenMessagesCubit, ScreenMessagesState>(
          builder: (context, state) => state.appBar,
        ),
      ),
      body: BlocBuilder<ScreenMessagesCubit, ScreenMessagesState>(
          builder: (context, state) {
        if (state is! ScreenMessageAwait) {
          return Column(
            children: <Widget>[
              Expanded(
                child: BlocBuilder<ScreenMessagesCubit, ScreenMessagesState>(
                  builder: (context, state) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: state.list.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            if (state.list[state.list.length - i - 1].id ==
                                context.read<ScreenMessagesCubit>().checkDate(
                                      state
                                          .list[state.list.length - i - 1].time,
                                      state.list[state.list.length - i - 1]
                                          .idMessagePage,
                                    ))
                              DateMessage(
                                index: state.list.length - i - 1,
                                idMessagePage: state.list.first.idMessagePage,
                              ),
                            Message(
                              index: state.list.length - i - 1,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              if (isVisibleCategories) _categoryLine(),
              _panelInput(),
            ],
          );
        } else {
          return Center(
            child: Text('Await'),
          );
        }
      }),
    );
  }

  Widget _categoryLine() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: BlocBuilder<ScreenMessagesCubit, ScreenMessagesState>(
        builder: (context, stateInput) => Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        isVisibleCategories = !isVisibleCategories;
                        setState(() {});
                        context
                            .read<ScreenMessagesCubit>()
                            .changeCategory(Icons.bubble_chart);
                      },
                    ),
                  ),
                  Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    6,
                    (index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Theme.of(context).accentColor,
                              child: IconButton(
                                icon: Icon(
                                  listIconCategory[index].icon,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  context
                                      .read<ScreenMessagesCubit>()
                                      .changeCategory(
                                          listIconCategory[index].icon);
                                  setState(() {});
                                },
                              ),
                            ),
                            Text(
                              listIconCategory[index].title,
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _category(IconData iconCategory, String categoryName) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: BlocBuilder<ScreenMessagesCubit, ScreenMessagesState>(
        builder: (context, stateInput) => Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(
                iconCategory,
                color: Colors.white,
              ),
            ),
            Text(
              categoryName,
            )
          ],
        ),
      ),
    );
  }

  Widget _panelInput() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: BlocBuilder<ScreenMessagesCubit, ScreenMessagesState>(
        builder: (context, stateInput) => Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(
                  Icons.bubble_chart,
                  // stateInput.category,
                ),
                onPressed: () {
                  isVisibleCategories = !isVisibleCategories;
                  setState(() {});
                },
              ),
            ),
            Expanded(
              flex: 5,
              child: TextField(
                controller: context.read<ScreenMessagesCubit>().controller,
                enabled: stateInput.enabledController,
                decoration: InputDecoration(
                  hintText: 'Enter event',
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(stateInput.iconData),
                onPressed: stateInput.onAddMessage,
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
    return BlocListener<ScreenMessagesCubit, ScreenMessagesState>(
      listener: (context, state) =>
          context.read<ScreenMessagesCubit>().toSelectionAppBar(),
      listenWhen: (prevState, curState) =>
          prevState.counter == 0 && curState.counter == 1 ? true : false,
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
            child: Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        )),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Navigator.pushNamed(
                context,
                SearchingPage.routeName,
              ),
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
    return BlocListener<ScreenMessagesCubit, ScreenMessagesState>(
      listener: (context, state) =>
          context.read<ScreenMessagesCubit>().toInputAppBar(),
      listenWhen: (prevState, curState) =>
          prevState.counter >= 1 && curState.counter == 0 ? true : false,
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: context.read<ScreenMessagesCubit>().backToInputAppBar,
        ),
        title: BlocBuilder<ScreenMessagesCubit, ScreenMessagesState>(
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
          BlocBuilder<ScreenMessagesCubit, ScreenMessagesState>(
            builder: (context, state) => state.counter == 1 &&
                    !context.read<ScreenMessagesCubit>().isPhotoMessage()
                ? Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed:
                          context.read<ScreenMessagesCubit>().toEditAppBar,
                    ),
                  )
                : Container(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.copy),
              onPressed: context.read<ScreenMessagesCubit>().copy,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.bookmark_border),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: context.read<ScreenMessagesCubit>().delete,
            ),
          ),
        ],
      ),
    );
  }

  void createDialog(BuildContext context) async {
    var index = 0;
    var list = await context.read<HomePageCubit>().repository.pagesList();
    list = list
        .where((element) =>
            element.id != context.read<ScreenMessagesCubit>().state.page.id)
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
                        .read<ScreenMessagesCubit>()
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
        onPressed: context.read<ScreenMessagesCubit>().backToInputAppBar,
      ),
      title: Center(
        child: Text(title),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: context.read<ScreenMessagesCubit>().backToInputAppBar,
          ),
        ),
      ],
    );
  }
}

class Message extends StatelessWidget {
  final int index;

  const Message({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<ScreenMessagesCubit>().state;
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment: BlocProvider.of<SettingPageCubit>(context)
                .state
                .isBubbleAlignmentSwitched
            ? Alignment.bottomRight
            : Alignment.bottomLeft,
        child: GestureDetector(
          onTap: state is ScreenMessageSelection
              ? () => context.read<ScreenMessagesCubit>().selection(index)
              : null,
          onLongPress: () =>
              context.read<ScreenMessagesCubit>().selection(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: BlocProvider.of<SettingPageCubit>(context)
                        .state
                        .isBubbleAlignmentSwitched
                    ? Radius.zero
                    : Radius.circular(10),
                bottomLeft: BlocProvider.of<SettingPageCubit>(context)
                        .state
                        .isBubbleAlignmentSwitched
                    ? Radius.circular(10)
                    : Radius.zero,
              ),
              border: Border.all(
                color: state.list[index].isSelected
                    ? Provider.of<ThemeModel>(context).currentTheme.primaryColor
                    : Colors.orange,
              ),
              color: state.list[index].isSelected
                  ? Provider.of<ThemeModel>(context)
                      .currentTheme
                      .backgroundColor
                  : Colors.orange[50],
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (state.list[index].icon != null)
                  Icon(state.list[index].icon),
                File(state.list[index].data).existsSync() == true
                    ? Image.file(
                        File(state.list[index].data),
                      )
                    : Text(
                        state.list[index].data,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                Text(
                  DateFormat('hh:mm').format(state.list[index].time),
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateMessage extends StatelessWidget {
  final int index;
  final int idMessagePage;
  final int idDateMessage;

  const DateMessage(
      {Key key, this.index, this.idMessagePage, this.idDateMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<ScreenMessagesCubit>().state;
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment: BlocProvider.of<SettingPageCubit>(context)
                .state
                .isDateAlignmentSwitched
            ? Alignment.bottomCenter
            : BlocProvider.of<SettingPageCubit>(context)
                    .state
                    .isBubbleAlignmentSwitched
                ? Alignment.bottomRight
                : Alignment.bottomLeft,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              border: Border.all(
                  color: Provider.of<ThemeModel>(context)
                      .currentTheme
                      .primaryColor),
              color: Provider.of<ThemeModel>(context)
                  .currentTheme
                  .backgroundColor),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context
                    .read<ScreenMessagesCubit>()
                    .calculateDate(state.list[index].time),
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
