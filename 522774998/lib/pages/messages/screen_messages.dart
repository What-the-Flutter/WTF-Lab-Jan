import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../enums/enums.dart';
import '../../repository/category_repository.dart';
import '../../theme/theme_cubit.dart';
import '../home/home_screen_cubit.dart';
import '../search/searching_message.dart';
import '../search/searching_messages_cubit.dart';
import '../settings/settings_page.dart';
import '../settings/settings_page_cubit.dart';
import 'screen_messages_cubit.dart';

bool isVisibleCategories = false;
Operation currentOperation = Operation.input;
final controller = TextEditingController();

class ScreenMessages extends StatefulWidget {
  static const routeName = '/ScreenMsg';

  @override
  _ScreenMessagesState createState() => _ScreenMessagesState();
}

class _ScreenMessagesState extends State<ScreenMessages>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _slideMessages;
  Animation<Offset> _slideDates;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _slideMessages = Tween(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    _slideDates = Tween(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    final indexBackground =
        BlocProvider.of<SettingPageCubit>(context).state.indexBackground;
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
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(galleryItems[indexBackground]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child:
                        BlocBuilder<ScreenMessagesCubit, ScreenMessagesState>(
                      builder: (context, state) {
                        return Stack(
                          children: [
                            ListView.builder(
                              reverse: true,
                              itemCount: state.list.length,
                              itemBuilder: (context, i) {
                                final isVisibleLabel = context
                                        .read<ScreenMessagesCubit>()
                                        .isPressed
                                    ? context
                                        .read<ScreenMessagesCubit>()
                                        .isVisibleLabelForBookmarks(state
                                            .list[state.list.length - i - 1])
                                    : context
                                        .read<ScreenMessagesCubit>()
                                        .isVisibleLabel(state
                                            .list[state.list.length - i - 1]);
                                return Column(
                                  children: [
                                    if (isVisibleLabel)
                                      SlideTransition(
                                        position: _slideDates,
                                        child: DateMessage(
                                          index: state.list.length - i - 1,
                                          idMessagePage:
                                              state.list.first.idMessagePage,
                                        ),
                                      ),
                                    if (state.list[state.list.length - i - 1]
                                        .isVisible)
                                      Dismissible(
                                        confirmDismiss: (direction) async {
                                          context
                                              .read<ScreenMessagesCubit>()
                                              .selection(
                                                  state.list.length - i - 1);
                                          if (direction ==
                                              DismissDirection.endToStart) {
                                            final res = await showDialog(
                                              context: context,
                                              builder: (alertContext) {
                                                return AlertDialog(
                                                  content: Text(
                                                      'Are you sure you want to delete?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                ScreenMessagesCubit>()
                                                            .toInputAppBar();
                                                        context
                                                            .read<
                                                                ScreenMessagesCubit>()
                                                            .selection(state
                                                                    .list
                                                                    .length -
                                                                i -
                                                                1);
                                                        Navigator.of(
                                                                alertContext)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                      onPressed: () {
                                                        _controller
                                                            .reverse()
                                                            .then((value) => context
                                                                .read<
                                                                    ScreenMessagesCubit>()
                                                                .delete())
                                                            .then((value) =>
                                                                Navigator.of(
                                                                        alertContext)
                                                                    .pop());
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            return res;
                                          } else {
                                            final res = await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      'Are you sure you want to edit?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                ScreenMessagesCubit>()
                                                            .toInputAppBar();
                                                        context
                                                            .read<
                                                                ScreenMessagesCubit>()
                                                            .selection(state
                                                                    .list
                                                                    .length -
                                                                i -
                                                                1);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                      ),
                                                      onPressed: () {
                                                        controller.text = context
                                                            .read<
                                                                ScreenMessagesCubit>()
                                                            .toEditAppBar();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            return res;
                                          }
                                        },
                                        background: _slideRightBackground(),
                                        secondaryBackground:
                                            _slideLeftBackground(),
                                        key: UniqueKey(),
                                        child: SlideTransition(
                                          position: _slideMessages,
                                          child: Message(
                                            index: state.list.length - i - 1,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            if (BlocProvider.of<SettingPageCubit>(context)
                                .state
                                .isDateModificationSwitched)
                              Align(
                                alignment:
                                    BlocProvider.of<SettingPageCubit>(context)
                                            .state
                                            .isBubbleAlignmentSwitched
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                child: DateMark(),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (isVisibleCategories) _categoryLine(),
                  _panelInput(),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('Await'),
            );
          }
        },
      ),
    );
  }

  Widget _slideRightBackground() {
    return Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _slideLeftBackground() {
    return Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    );
  }

  Widget _categoryLine() {
    return Container(
      color: Colors.white,
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
                              backgroundColor:
                                  BlocProvider.of<ThemeCubit>(context)
                                      .state
                                      .theme
                                      .accentColor,
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
              backgroundColor:
                  BlocProvider.of<ThemeCubit>(context).state.theme.accentColor,
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
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: BlocBuilder<ScreenMessagesCubit, ScreenMessagesState>(
        builder: (context, stateInput) => Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(
                  context.read<ScreenMessagesCubit>().state.category ??
                      Icons.bubble_chart,
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
                controller: controller,
                enabled: stateInput.enabledController,
                decoration: InputDecoration(
                  hintText: 'Enter event',
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    debugPrint('Add message');
                    stateInput is ScreenMessageInput
                        ? context
                            .read<ScreenMessagesCubit>()
                            .addTextMessage(controller.text)
                        : context
                            .read<ScreenMessagesCubit>()
                            .editMessage(controller.text);
                  }
                  controller.text = '';
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () {
                  stateInput is ScreenMessageInput
                      ? context.read<ScreenMessagesCubit>().addPhotoMessage()
                      : context
                          .read<ScreenMessagesCubit>()
                          .editMessage(controller.text);
                  controller.text = '';
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class InputAppBar extends StatefulWidget {
  final String title;

  const InputAppBar({Key key, this.title}) : super(key: key);

  @override
  _InputAppBarState createState() => _InputAppBarState();
}

class _InputAppBarState extends State<InputAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScreenMessagesCubit, ScreenMessagesState>(
      listener: (context, state) =>
          context.read<ScreenMessagesCubit>().toSelectionAppBar(),
      listenWhen: (prevState, curState) =>
          prevState.counter == 0 && curState.counter == 1 ? true : false,
      builder: (context, state) => AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.read<ScreenMessagesCubit>().showAll();
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  context.read<SearchMessageCubit>().isAll = false;
                  Navigator.pushNamed(
                    context,
                    SearchingPage.routeName,
                  );
                }),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: IconButton(
              icon: context.read<ScreenMessagesCubit>().isPressed
                  ? Icon(
                      Icons.bookmark,
                      color: Colors.yellow,
                    )
                  : Icon(Icons.bookmark_border),
              onPressed: () {
                context.read<ScreenMessagesCubit>().selectBookmarks();
                context.read<ScreenMessagesCubit>().isPressed
                    ? context.read<ScreenMessagesCubit>().showBookmarks()
                    : context.read<ScreenMessagesCubit>().showAll();
              },
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
                      onPressed: () {
                        controller.text =
                            context.read<ScreenMessagesCubit>().toEditAppBar();
                      },
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
              onPressed: () {
                context.read<ScreenMessagesCubit>().makeBookmarkSelected();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => context.read<ScreenMessagesCubit>().delete(),
            ),
          ),
        ],
      ),
    );
  }

  void createDialog(BuildContext context) async {
    var index = 0;
    var list = await context.read<HomeScreenCubit>().repository.pagesList();
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
                  onPressed: () => Navigator.pop(alertContext),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: BlocProvider.of<ThemeCubit>(context)
                              .state
                              .theme
                              .primaryColor),
                    ),
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
                    Navigator.pop(alertContext);
                  },
                  child: Center(
                    child: Text(
                      'Choose',
                      style: TextStyle(
                          color: BlocProvider.of<ThemeCubit>(context)
                              .state
                              .theme
                              .primaryColor),
                    ),
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

  const EditAppBar({Key key, this.title}) : super(key: key);

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
              : () => context.read<ScreenMessagesCubit>().makeBookmark(index),
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
                    ? BlocProvider.of<ThemeCubit>(context)
                        .state
                        .theme
                        .primaryColor
                    : Colors.orange,
              ),
              color: state.list[index].isSelected
                  ? BlocProvider.of<ThemeCubit>(context)
                      .state
                      .theme
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
                    ? Container(
                        width: 150,
                        height: 250,
                        child: Image.file(
                          File(state.list[index].data),
                        ),
                      )
                    : HashTagText(
                        text: state.list[index].data,
                        basicStyle: TextStyle(
                          fontSize: BlocProvider.of<SettingPageCubit>(context)
                              .state
                              .fontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                        decoratedStyle: TextStyle(
                          fontSize: BlocProvider.of<SettingPageCubit>(context)
                              .state
                              .fontSize,
                          color: Colors.deepPurple,
                        ),
                        onTap: (text) {
                          context.read<SearchMessageCubit>().isAll = false;
                          BlocProvider.of<SearchMessageCubit>(context)
                              .controller
                              .text = text;
                          Navigator.pushNamed(
                            context,
                            SearchingPage.routeName,
                          );
                        },
                      ),
                Wrap(
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(state.list[index].time),
                      style: TextStyle(
                          fontSize: BlocProvider.of<SettingPageCubit>(context)
                              .state
                              .fontSize,
                          color: Colors.grey),
                    ),
                    if (state.list[index].isBookmark)
                      Icon(
                        Icons.bookmark,
                        color: Colors.yellow,
                        size: 20,
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

class DateMessage extends StatelessWidget {
  final int index;
  final int idMessagePage;
  final int idDateMessage;

  const DateMessage({
    Key key,
    this.index,
    this.idMessagePage,
    this.idDateMessage,
  }) : super(key: key);

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
                  color: BlocProvider.of<ThemeCubit>(context)
                      .state
                      .theme
                      .primaryColor),
              color: BlocProvider.of<ThemeCubit>(context)
                  .state
                  .theme
                  .backgroundColor),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Text(
            context
                .read<ScreenMessagesCubit>()
                .calculateDate(state.list[index].time),
            style: TextStyle(
              fontSize:
                  BlocProvider.of<SettingPageCubit>(context).state.fontSize,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class DateMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.read<ScreenMessagesCubit>().state;
    final date = state.dateOfSending ??
        context.read<ScreenMessagesCubit>().calculateDate(DateTime.now());
    return GestureDetector(
      onTap: () async {
        var date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2025),
          builder: (context, child) {
            return SingleChildScrollView(
              child: Theme(
                child: child,
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: BlocProvider.of<ThemeCubit>(context)
                          .state
                          .theme
                          .primaryColor),
                ),
              ),
            );
          },
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(date),
            builder: (context, child) {
              return SingleChildScrollView(
                child: Theme(
                  child: child,
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: BlocProvider.of<ThemeCubit>(context)
                            .state
                            .theme
                            .primaryColor,
                        surface: Colors.white),
                  ),
                ),
              );
            },
          );
          if (time != null) {
            date = DateTime(
                date.year, date.month, date.day, time.hour, time.minute);
          }
        }
        context.read<ScreenMessagesCubit>().selectDate(date);
        context.read<ScreenMessagesCubit>().selectTime(date);
      },
      child: UnconstrainedBox(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              border: Border.all(
                  color: BlocProvider.of<ThemeCubit>(context)
                      .state
                      .theme
                      .primaryColor),
              color: BlocProvider.of<ThemeCubit>(context)
                  .state
                  .theme
                  .backgroundColor),
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: BlocBuilder<ScreenMessagesCubit, ScreenMessagesState>(
            builder: (context, state) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.today,
                  size: 20,
                ),
                Text(
                  date,
                  style: TextStyle(
                      fontSize: BlocProvider.of<SettingPageCubit>(context)
                          .state
                          .fontSize,
                      color: Colors.black),
                ),
                SizedBox(
                  width: 10,
                ),
                if (date != 'Today')
                  GestureDetector(
                    onTap: () {
                      context.read<ScreenMessagesCubit>().resetDate();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      radius: 10,
                      child: Icon(
                        Icons.close,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
