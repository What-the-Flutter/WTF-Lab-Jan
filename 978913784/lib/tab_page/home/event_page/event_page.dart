import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/icon_list.dart';
import '../../../entity/page.dart';
import '../../settings_page/settings_cubit.dart';
import '../../../tab_page/home/pages_cubit.dart';
import '../../../widgets/event_message_list.dart';
import '../../../widgets/event_message_tile.dart';
import 'events_cubit.dart';
import 'events_state.dart';

class EventPage extends StatefulWidget {
  EventPage(this.page, {Key key}) : super(key: key);

  final JournalPage page;

  @override
  _EventPageState createState() => _EventPageState(page);
}

class _EventPageState extends State<EventPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  EventCubit cubit;

  _EventPageState(JournalPage page) {
    cubit = EventCubit(EventsState(page));
    cubit.initialize(page);
  }

  Widget get _infoAppBar {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).accentIconTheme,
      actions: [
        IconButton(
          onPressed: () => cubit.showFavourites(!cubit.state.showingFavourites),
          icon: Icon(
            cubit.state.showingFavourites
                ? Icons.star
                : Icons.star_border_outlined,
          ),
        ),
        IconButton(
          onPressed: () {
            cubit.setOnSearch(true);
          },
          icon: Icon(Icons.search),
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
                color: Theme.of(context).textTheme.bodyText2.color,
                fontSize: SettingsCubit.calculateSize(context, 15, 20, 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _searchAppBar {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          cubit.setOnSearch(false);
          _controller.clear();
        },
      ),
      title: Expanded(
        child: Text(
          'Searching',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyText2.color,
            fontSize: SettingsCubit.calculateSize(context, 15, 20, 30),
          ),
        ),
      ),
      iconTheme: Theme.of(context).accentIconTheme,
    );
  }

  Widget get _editAppBar {
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: Theme.of(context).accentColor,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Icon(
                        iconList[BlocProvider.of<PagesCubit>(context)
                            .state[index]
                            .iconIndex],
                        color: Theme.of(context).textTheme.bodyText2.color,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          BlocProvider.of<PagesCubit>(context)
                              .state[index]
                              .title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyText2.color,
                            fontSize: SettingsCubit.calculateSize(
                                context, 15, 18, 25),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        title: Center(
          child: Text('Select a page'),
        ),
        content: _content(),
      );
    }

    IconButton _closeButton() {
      return IconButton(
        onPressed: () {
          _controller.clear();
          cubit.setSelectionMode(false);
        },
        icon: Icon(Icons.clear),
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
        icon: Icon(Icons.reply),
      );
    }

    IconButton _editButton() {
      return IconButton(
        onPressed: () {
          _controller.text = cubit.state.selected.first.description;
          _focusNode.requestFocus();
          cubit.setOnEdit(true);
        },
        icon: Icon(Icons.edit_outlined),
      );
    }

    IconButton _deleteButton() {
      return IconButton(
        onPressed: () {
          cubit.deleteEvents();
          cubit.setSelectionMode(false);
        },
        icon: Icon(Icons.delete_outline),
      );
    }

    IconButton _favouritesButton() {
      return IconButton(
        onPressed: () {
          cubit.addToFavourites();
          cubit.setSelectionMode(false);
        },
        icon: Icon(
          cubit.state.areAllFavourites()
              ? Icons.star
              : Icons.star_border_outlined,
        ),
      );
    }

    IconButton _copyButton() {
      return IconButton(
        onPressed: () {
          FlutterClipboard.copy(cubit.state.selected.first.description);
          cubit.setSelectionMode(false);
        },
        icon: Icon(Icons.copy),
      );
    }

    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      title: Text(
        cubit.state.selected.length.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyText2.color,
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
            .where((element) => element.description.contains(_controller.text))
            .toList()
        : cubit.state.events;

    final _displayed = cubit.state.showingFavourites
        ? _allowed.where((event) => event.isFavourite).toList()
        : _allowed;

    return EventMessageList(
      _displayed,
      cubit.state.selected,
      cubit.state.isDateCentered,
      cubit.state.isRightToLeft,
      builder: (event) {
        return EventMessageTile(
          event,
          cubit.state.isRightToLeft,
          true,
          cubit.state.selected.contains(event),
          onTap: () {
            if (cubit.state.isOnSelectionMode) {
              cubit.selectEvent(event);
            }
          },
          onLongPress: () {
            cubit.setSelectionMode(true);
            cubit.selectEvent(event);
          },
          onHashTap: (text) {
            cubit.setOnSearch(true);
            _controller.text = text;
          },
          onDelete: (event) => cubit.deleteSingle(event),
          onEdit: (event) {
            cubit.setSelectionMode(true);
            cubit.selectEvent(event);
            _controller.text = event.description;
            _focusNode.requestFocus();
            cubit.setOnEdit(true);
          },
        );
      },
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
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
                title: Text(
                  'Take a photo',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontSize: SettingsCubit.calculateSize(context, 12, 15, 20),
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  var image =
                      await ImagePicker().getImage(source: ImageSource.camera);
                  if (image != null) {
                    cubit.addEventFromResource(File(image.path));
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo,
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
                title: Text(
                  'Pick from gallery',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontSize: SettingsCubit.calculateSize(context, 12, 15, 20),
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  var image =
                      await ImagePicker().getImage(source: ImageSource.gallery);
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
            cubit.editEvent(_controller.text, cubit.state.selected.first);
          } else {
              cubit.addEvent(
                _controller.text,
              );
          }
          _controller.clear();
          cubit.setCanSelectImage(true);
        }
      },
      child: Icon(
        cubit.state.canSelectImage
            ? Icons.photo_camera
            : cubit.state.isOnEdit
                ? Icons.check
                : Icons.send,
        color: Theme.of(context).textTheme.bodyText2.color,
        size: 18,
      ),
      backgroundColor: Theme.of(context).accentColor,
      elevation: 0,
    );
  }

  Widget get _textField {
    return TextField(
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyText1.color,
        fontSize: SettingsCubit.calculateSize(context, 12, 15, 20),
      ),
      onChanged: (text) {
        if (cubit.state.isSearching) {
          cubit.setOnSearch(true);
        } else {
          cubit.setCanSelectImage(text.isEmpty);
        }
      },
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Write event description...',
        hintStyle: TextStyle(
          color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5),
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
            padding: EdgeInsets.all(10),
            maxCrossAxisExtent: 100,
            children: [
              for (var index = 0; index < eventIconList.length; index++)
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
                          foregroundColor:
                              Theme.of(context).textTheme.bodyText2.color,
                          child: Icon(eventIconList[index]),
                        ),
                        Expanded(
                          child: Text(
                            eventStringList[index],
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              fontSize: SettingsCubit.calculateSize(
                                  context, 12, 15, 20),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        title: Center(
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
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .color
                    .withOpacity(0.2),
              ),
            ),
          ),
          padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
          height: 60,
          width: double.infinity,
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
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: _textField,
              ),
              SizedBox(
                width: 5,
              ),
              if (!cubit.state.isSearching) _floatingActionButton,
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: state.isOnSelectionMode
              ? _editAppBar
              : state.isSearching
                  ? _searchAppBar
                  : _infoAppBar,
          body: Stack(
            children: [
              _body,
              Align(
                alignment: cubit.state.isRightToLeft
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(2))),
                    child: cubit.state.isDateSelected
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.close,
                                size: 17,
                              ),
                              Text(
                                DateFormat('dd.MM.yyyy HH:mm')
                                    .format(cubit.state.date),
                              ),
                            ],
                          )
                        : Text('Set date'),
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
                            date = DateTime(date.year, date.month, date.day,
                                time.hour, time.minute);
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
