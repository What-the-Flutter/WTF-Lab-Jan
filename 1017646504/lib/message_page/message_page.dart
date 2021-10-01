import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../data/icons.dart';
import '../entity/page.dart';
import '../main_page/pages_cubit.dart';
import '../settings_page/settings_cubit.dart';
import 'messages_cubit.dart';
import 'messages_state.dart';

class MessagePage extends StatefulWidget {
  MessagePage(this.page, {Key? key}) : super(key: key);

  final JournalPage page;

  @override
  _MessagePageState createState() => _MessagePageState(page);
}

class _MessagePageState extends State<MessagePage> {
  final controller = TextEditingController();
  final _focusNode = FocusNode();

  late MessageCubit cubit;

  _MessagePageState(JournalPage page) {
    cubit = MessageCubit(MessagesState(page));
    cubit.initialize(page);
  }

  PreferredSizeWidget get _infoAppBar {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).accentIconTheme,
      actions: [
        IconButton(
          onPressed: () => cubit.showFavourites(!cubit.state.showingFavourites),
          icon: Icon(
            cubit.state.showingFavourites ? Icons.star : Icons.star_border_outlined,
          ),
        ),
        IconButton(
          onPressed: () => cubit.setOnSearch(true),
          icon: const Icon(Icons.search),
        ),
      ],
      title: Row(
        children: [
          Icon(iconList[cubit.state.page.iconIndex]),
          Expanded(
            child: Text(
              cubit.state.page.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyText2!.color,
                fontSize: SettingsCubit.calculateSize(context, 15, 20, 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget get _searchAppBar {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          cubit.setOnSearch(false);
          controller.clear();
        },
      ),
      title: Expanded(
        child: Text(
          'Searching',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyText2!.color,
            fontSize: SettingsCubit.calculateSize(context, 15, 20, 30),
          ),
        ),
      ),
      iconTheme: Theme.of(context).accentIconTheme,
    );
  }

  PreferredSizeWidget get _editAppBar {
    Widget _iconDialog() {
      Widget _content() {
        return Container(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: BlocProvider.of<PagesCubit>(context).state.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  cubit.acceptForward(
                    BlocProvider.of<PagesCubit>(context).state[index],
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(35),
                    ),
                    color: Theme.of(context).accentColor,
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Icon(
                        iconList[BlocProvider.of<PagesCubit>(context).state[index].iconIndex],
                        color: Theme.of(context).textTheme.bodyText2!.color,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          BlocProvider.of<PagesCubit>(context).state[index].title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyText2!.color,
                            fontSize: SettingsCubit.calculateSize(context, 15, 18, 25),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }

      return AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        title: const Center(
          child: Text('Select a page'),
        ),
        content: _content(),
      );
    }

    IconButton _closeButton() {
      return IconButton(
        onPressed: () {
          controller.clear();
          cubit.setSelectionMode(false);
        },
        icon: const Icon(Icons.clear),
      );
    }

    IconButton _forwardButton() {
      return IconButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => _iconDialog(),
          );
        },
        icon: const Icon(Icons.reply),
      );
    }

    IconButton _editButton() {
      return IconButton(
        onPressed: () {
          controller.text = cubit.state.selected.first.description;
          _focusNode.requestFocus();
          cubit.setOnEdit(true);
        },
        icon: const Icon(Icons.edit_outlined),
      );
    }

    IconButton _deleteButton() {
      return IconButton(
        onPressed: () {
          cubit.deleteEvents();
          cubit.setSelectionMode(false);
        },
        icon: const Icon(Icons.delete_outline),
      );
    }

    IconButton _favouritesButton() {
      return IconButton(
        onPressed: () {
          cubit.addToFavourites();
          cubit.setSelectionMode(false);
        },
        icon: Icon(
          cubit.state.areAllFavourites() ? Icons.star : Icons.star_border_outlined,
        ),
      );
    }

    IconButton _copyButton() {
      return IconButton(
        onPressed: () {
          FlutterClipboard.copy(cubit.state.selected.first.description);
          cubit.setSelectionMode(false);
        },
        icon: const Icon(Icons.copy),
      );
    }

    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      title: Text(
        cubit.state.selected.length.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyText2!.color,
          fontSize: SettingsCubit.calculateSize(context, 15, 20, 30),
        ),
      ),
      leading: _closeButton(),
      iconTheme: Theme.of(context).accentIconTheme,
      actions: [
        _forwardButton(),
        if (cubit.state.selected.length == 1) _editButton(),
        _deleteButton(),
        _favouritesButton(),
        if (cubit.state.selected.length == 1) _copyButton(),
      ],
    );
  }

  Widget get _listView {
    final _allowed = cubit.state.isSearching
        ? cubit.state.events
            .where((element) => element.description.contains(controller.text))
            .toList()
        : cubit.state.events;

    final _displayed = cubit.state.showingFavourites
        ? _allowed.where((event) => event.isFavourite).toList()
        : _allowed;

    if (_displayed.isNotEmpty) {
      final _children = <Widget>[const SizedBox(height: 50)];
      final days = <int>{};
      for (var i = _displayed.length - 1; i >= 0; i--) {
        final day = _displayed[i].creationTime.millisecondsSinceEpoch ~/ 86400000;
        if (!days.contains(day)) {
          _children.insert(
            0,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Text(
                DateFormat('MMM d, yyyy').format(_displayed[i].creationTime),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: SettingsCubit.calculateSize(context, 15, 18, 25),
                ),
                textAlign: cubit.state.isDateCentered
                    ? TextAlign.center
                    : BlocProvider.of<SettingsCubit>(context).state.isRightToLeft
                        ? TextAlign.end
                        : TextAlign.start,
              ),
            ),
          );
          days.add(day);
        }
        _children.insert(0, _listItem(_displayed[i], i));
      }

      return ListView(
        reverse: true,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: _children,
      );
    } else {
      return Center(
        child: Text(
          'No events yet...',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5),
            fontSize: SettingsCubit.calculateSize(context, 15, 20, 30),
          ),
        ),
      );
    }
  }

  Widget _listItem(Event event, int index) {
    Widget _title(Event event) {
      return Row(
        children: [
          Icon(
            eventIconList[event.iconIndex],
            color: Theme.of(context).textTheme.bodyText2!.color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              eventStringList[event.iconIndex],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyText2!.color,
                fontSize: SettingsCubit.calculateSize(context, 15, 20, 30),
              ),
            ),
          )
        ],
      );
    }

    Widget _content(Event event) {
      return event.imagePath.isEmpty
          ? HashTagText(
              text: event.description,
              basicStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyText2!.color,
                fontSize: SettingsCubit.calculateSize(context, 12, 15, 20),
              ),
              decoratedStyle: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: SettingsCubit.calculateSize(context, 12, 15, 20),
              ),
              onTap: (text) {
                cubit.setOnSearch(true);
                controller.text = text;
              },
            )
          : Image.memory(File(event.imagePath).readAsBytesSync());
    }

    return GestureDetector(
      onTap: () {
        if (cubit.state.isOnSelectionMode) {
          cubit.selectEvent(event);
        }
      },
      onLongPress: () {
        cubit.setSelectionMode(true);
        cubit.selectEvent(event);
      },
      child: Container(
        margin: cubit.state.isRightToLeft
            ? const EdgeInsets.only(top: 2, bottom: 2, left: 100, right: 5)
            : const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            bottomLeft: cubit.state.isRightToLeft ? const Radius.circular(10) : Radius.zero,
            topRight: const Radius.circular(10),
            bottomRight: cubit.state.isRightToLeft ? Radius.zero : const Radius.circular(10),
          ),
          color: cubit.state.selected.contains(event)
              ? Theme.of(context).shadowColor
              : Theme.of(context).accentColor,
        ),
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.iconIndex != 0) _title(event),
            _content(event),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: event.isFavourite
                      ? const Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.star,
                            color: Colors.yellowAccent,
                            size: 12,
                          ),
                        )
                      : Container(),
                ),
                Text(
                  DateFormat('HH:mm').format(event.creationTime),
                  style: TextStyle(
                    fontSize: SettingsCubit.calculateSize(context, 10, 12, 20),
                    color: Theme.of(context).textTheme.bodyText2!.color,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _floatingActionButton {
    void _showBottomSheet() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).primaryColor,
        builder: (context) {
          return Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                title: Text(
                  'Take a photo',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: SettingsCubit.calculateSize(context, 12, 15, 20),
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (image != null) {
                    cubit.addEventFromResource(File(image.path));
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                title: Text(
                  'Pick from gallery',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: SettingsCubit.calculateSize(context, 12, 15, 20),
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    print(image.path);
                    cubit.addEventFromResource(File(image.path));
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return FloatingActionButton(
      onPressed: () {
        if (cubit.state.canSelectImage) {
          _showBottomSheet();
        } else {
          if (cubit.state.isOnEdit) {
            cubit.editEvent(controller.text);
          } else {
            cubit.addEvent(
              controller.text,
            );
          }
          controller.clear();
        }
      },
      child: Icon(
        cubit.state.canSelectImage
            ? Icons.photo_camera
            : cubit.state.isOnEdit
                ? Icons.check
                : Icons.send,
        color: Theme.of(context).textTheme.bodyText2!.color,
        size: 18,
      ),
      backgroundColor: Theme.of(context).accentColor,
      elevation: 0,
    );
  }

  Widget get _textField {
    return TextField(
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyText1!.color,
        fontSize: SettingsCubit.calculateSize(context, 12, 15, 20),
      ),
      onChanged: (text) {
        if (cubit.state.isSearching) {
          cubit.setOnSearch(true);
        } else {
          cubit.setCanSelectImage(text.isEmpty);
        }
      },
      controller: controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Write event description...',
        hintStyle: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5),
          fontSize: SettingsCubit.calculateSize(context, 12, 15, 20),
        ),
        border: InputBorder.none,
      ),
    );
  }

  Widget get _body {
    Widget _iconDialog() {
      Widget _content() {
        return Container(
          width: double.maxFinite,
          child: GridView.extent(
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(10),
            maxCrossAxisExtent: 100,
            children: [
              for (int index = 0; index < eventIconList.length; index++)
                GestureDetector(
                  onTap: () async {
                    cubit.selectIcon(index);
                    Navigator.pop(context, index);
                  },
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).accentColor,
                          foregroundColor: Theme.of(context).textTheme.bodyText2!.color,
                          child: Icon(eventIconList[index]),
                        ),
                        Expanded(
                          child: Text(
                            eventStringList[index],
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: SettingsCubit.calculateSize(context, 12, 15, 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }

      return AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        title: const Center(
          child: Text('Select a category'),
        ),
        content: _content(),
      );
    }

    return Column(
      children: [
        Expanded(
          child: _listView,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Row(
              children: <Widget>[
                if (!cubit.state.isSearching)
                  IconButton(
                    icon: Icon(
                      cubit.state.selectedIconIndex == 0
                          ? Icons.insert_emoticon
                          : eventIconList[cubit.state.selectedIconIndex],
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => _iconDialog(),
                      );
                    },
                  ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: _textField,
                ),
                const SizedBox(
                  width: 5,
                ),
                if (!cubit.state.isSearching) _floatingActionButton,
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: cubit.state.isOnSelectionMode
              ? _editAppBar
              : cubit.state.isSearching
                  ? _searchAppBar
                  : _infoAppBar,
          body: Stack(
            children: [
              _body,
              Align(
                alignment: cubit.state.isRightToLeft ? Alignment.topLeft : Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.all(2))),
                    child: cubit.state.isDateSelected
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.close,
                                size: 17,
                              ),
                              Text(
                                DateFormat('dd.MM.yyyy HH:mm').format(cubit.state.date),
                              ),
                            ],
                          )
                        : const Text('Set date'),
                    onPressed: () async {
                      if (cubit.state.isDateSelected) {
                        cubit.setDate(null);
                      } else {
                        var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2025),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(date),
                          );
                          if (time != null) {
                            date =
                                DateTime(date.year, date.month, date.day, time.hour, time.minute);
                            cubit.setDate(date);
                          }
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
