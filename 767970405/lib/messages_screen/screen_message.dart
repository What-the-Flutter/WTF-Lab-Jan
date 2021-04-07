import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../data/repository/category_repository.dart';
import '../data/theme/custom_theme.dart';
import '../home_screen/home_screen_cubit.dart';
import '../search_messages_screen/search_message_screen.dart';
import '../settings_screen/setting_screen_cubit.dart';
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

  Widget get body => BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
        builder: (context, state) {
          final backImage =
              context.read<SettingScreenCubit>().state.pathBackgroundImage;
          return Stack(
            children: <Widget>[
              backImage.isNotEmpty
                  ? Image.file(
                      File(backImage),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )
                  : Container(),
              Column(
                children: <Widget>[
                  Expanded(
                    child: ChatElementList(
                      alignment: context
                              .read<SettingScreenCubit>()
                              .state
                              .isLeftBubbleAlign
                          ? Alignment.topLeft
                          : Alignment.topRight,
                      isDateTimeModEnabled: context
                          .read<SettingScreenCubit>()
                          .state
                          .isDateTimeModification,
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      switch (state.floatingBar) {
                        case FloatingBar.nothing:
                          return Container();
                        case FloatingBar.category:
                          return CategoryList();
                        case FloatingBar.photosOption:
                          return AttachPhotoOption();
                        case FloatingBar.tag:
                          return state.listTag == ModeListTag.listTags
                              ? TagList()
                              : Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.red,
                                  ),
                                  child: Text('Add new Tag: ${state.curTag}'),
                                );
                        default:
                          return Container();
                      }
                    },
                  ),
                  InputPanel(),
                ],
              ),
            ],
          );
        },
      );
}

class TagList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.read<ScreenMessageCubit>().state;
    return Container(
      constraints: BoxConstraints(maxHeight: 60),
      padding: EdgeInsets.all(5.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.tags.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.red,
              ),
              child: Text(state.tags[index].name),
            ),
          ),
        ),
      ),
    );
  }
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
    final generalOptionState = context.read<SettingScreenCubit>().state;
    return Stack(
      alignment: alignment,
      children: <Widget>[
        ListView(
          reverse: true,
          children: _generateChatElementsList(
            context,
            context.read<ScreenMessageCubit>().state,
          ),
        ),
        if (isDateTimeModEnabled)
          BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
            builder: (context, state) => DateTimeModButton(
              date: DateFormat.yMMMEd().format(state.fromDate),
              theme: DateTimeModButtonTheme(
                backgroundColor:
                    generalOptionState.dateTimeModeButtonBackgroundColor,
                iconColor: generalOptionState.dateTimeModeButtonIconColor,
                dateStyle: TextStyle(
                  fontSize: generalOptionState.bodyFontSize,
                  color: generalOptionState.titleColor,
                ),
              ),
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
    final generalOptionState = context.read<SettingScreenCubit>().state;
    final messageTheme = MessageTheme(
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
    );
    final dateLabelTheme = LabelDateTheme(
      backgroundColor: generalOptionState.labelDateBackgroundColor,
      dateStyle: TextStyle(
        fontSize: generalOptionState.bodyFontSize,
        color: generalOptionState.bodyColor,
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
            align: context.read<SettingScreenCubit>().state.isLeftBubbleAlign
                ? Alignment.topRight
                : Alignment.topLeft,
            onTap: state.mode == Mode.selection
                ? context.read<ScreenMessageCubit>().selection
                : null,
            onLongPress: state.mode == Mode.input
                ? context.read<ScreenMessageCubit>().toSelectionAppBar
                : state.mode == Mode.selection
                    ? context.read<ScreenMessageCubit>().selection
                    : null,
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
              context.read<SettingScreenCubit>().state.isCenterDateBubble
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
    final state = context.read<ScreenMessageCubit>().state;
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
                onPressed: context.read<ScreenMessageCubit>().reset,
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
    BuildContext context,
    ScreenMessageState state,
  ) async {
    final datePicked = await _showDatePicker(context, state.fromDate);

    final timePicked = await _showTimePicker(context, state.fromTime);
    context
        .read<ScreenMessageCubit>()
        .updateDateAndTime(date: datePicked, time: timePicked);
  }

  Future<TimeOfDay> _showTimePicker(
    BuildContext context,
    TimeOfDay initialTime,
  ) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
  }

  Future<DateTime> _showDatePicker(
    BuildContext context,
    DateTime initialDate,
  ) async {
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
                icon: Icon(
                  state.indexCategory == -1
                      ? Icons.bubble_chart
                      : RepositoryProvider.of<CategoryRepository>(context)
                          .events[state.indexCategory]
                          .iconData,
                ),
                onPressed:
                    state.mode == Mode.selection ? null : state.onAddCategory,
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
                icon: Icon(state.iconDataPhoto),
                onPressed:
                    state.mode == Mode.selection ? null : state.onAddMessage,
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
    return AppBar(
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
              onPressed: context.read<ScreenMessageCubit>().deleteSelected,
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
                    title: Text(
                      list[i].title,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
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
                    context.read<ScreenMessageCubit>().listSelected(
                          list[index].id,
                        );
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

class AttachPhotoOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AttachPhotoButton(
          iconData: Icons.camera_alt_outlined,
          text: 'Open Camera',
          source: ImageSource.camera,
        ),
        AttachPhotoButton(
          iconData: Icons.photo,
          text: 'Open Gallery',
          source: ImageSource.gallery,
        ),
      ],
    );
  }
}

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories =
        RepositoryProvider.of<CategoryRepository>(context).events;
    return Container(
      constraints: BoxConstraints(maxHeight: 70),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: context.read<ScreenMessageCubit>().cancelSelected,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: Icon(Icons.close),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                    Text('Cancel'),
                  ],
                ),
              ),
            );
          }
          return CategoryMessage(
            index: index - 1,
            iconData: categories[index - 1].iconData,
            label: categories[index - 1].label,
            color: Colors.teal,
            direction: Axis.vertical,
            onTap: context.read<ScreenMessageCubit>().selectedCategory,
          );
        },
      ),
    );
  }
}

class CategoryMessage extends StatelessWidget {
  final int index;
  final IconData iconData;
  final String label;
  final Color color;
  final Axis direction;
  final Function onTap;

  CategoryMessage({
    Key key,
    this.index,
    this.iconData,
    this.label,
    this.color,
    this.direction,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap(index) : onTap,
      child: Padding(
        padding: direction == Axis.vertical
            ? EdgeInsets.symmetric(horizontal: 10.0)
            : EdgeInsets.only(),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: direction,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Icon(
                iconData,
                color: Colors.white,
              ),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class AttachPhotoButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final ImageSource source;

  const AttachPhotoButton({
    Key key,
    this.iconData,
    this.source,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<ScreenMessageCubit>().addPhotoMessage(source),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.red,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                iconData,
                color: Colors.white,
              ),
            ),
            Text(text),
          ],
        ),
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
  final String title;
  final String photoPath;
  final int eventIndex;
  final String text;
  final bool isFavor;
  final String date;
  final AlignmentGeometry align;
  final Function onTap;
  final Function onLongPress;
  final MessageTheme theme;

  const Message({
    Key key,
    this.index,
    this.isSelected,
    this.title,
    this.photoPath,
    this.isFavor,
    this.eventIndex,
    this.text,
    this.date,
    this.align,
    this.onTap,
    this.onLongPress,
    this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.indigo,
          icon: Icons.edit,
          onTap: () async {
            await context.read<ScreenMessageCubit>().selection(index);
            context.read<ScreenMessageCubit>().toEditAppBar();
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            await context.read<ScreenMessageCubit>().toSelectionAppBar(index);
            context.read<ScreenMessageCubit>().deleteSelected();
          },
        ),
      ],
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Align(
          alignment: align,
          child: GestureDetector(
            onTap: onTap != null ? () => onTap(index) : onTap,
            onLongPress:
                onLongPress != null ? () => onLongPress(index) : onLongPress,
            child: Stack(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxWidth: 150),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: isSelected
                        ? theme.selectedColor
                        : theme.unselectedColor,
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (title != null)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(title),
                        ),
                      if (photoPath != null)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Image.file(
                            File(photoPath),
                          ),
                        ),
                      if (eventIndex != -1)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: CategoryMessage(
                            iconData: Provider.of<CategoryRepository>(context)
                                .events[eventIndex]
                                .iconData,
                            label: Provider.of<CategoryRepository>(context)
                                .events[eventIndex]
                                .label,
                            color: Colors.teal,
                            direction: Axis.horizontal,
                          ),
                        ),
                      if (text != null)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: _contentMsg(theme.contentStyle),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              date,
                              style: theme.timeStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isFavor)
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.orangeAccent,
                      size: 10,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contentMsg(TextStyle defaultStyle) {
    final words = text.split(' ');
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          for (var i = 0; i < words.length; i++)
            words[i].startsWith('#')
                ? TextSpan(
                    text: words[i] + (i != words.length - 1 ? ' ' : ''),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  )
                : TextSpan(
                    text: words[i] + (i != words.length - 1 ? ' ' : ''),
                    style: defaultStyle,
                  ),
        ],
      ),
    );
  }
}
