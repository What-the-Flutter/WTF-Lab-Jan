import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/icon_list.dart';
import '../../../entity/page.dart';
import '../../../tab_page/home/pages_cubit.dart';
import '../../../widgets/event_message_list.dart';
import '../../../widgets/event_message_tile.dart';
import '../../settings_page/settings_cubit.dart';
import 'events_cubit.dart';

class EventPage extends StatefulWidget {
  EventPage(this.page, {Key key}) : super(key: key);

  final JournalPage page;

  @override
  _EventPageState createState() => _EventPageState(page);
}

class _EventPageState extends State<EventPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  final JournalPage page;

  _EventPageState(this.page);

  @override
  void initState() {
    BlocProvider.of<EventCubit>(context).initialize(page);
    super.initState();
  }

  Widget get _infoAppBar {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).accentIconTheme,
      actions: [
        IconButton(
          onPressed: () => BlocProvider.of<EventCubit>(context).showFavourites(
            !BlocProvider.of<EventCubit>(context).state.showingFavourites,
          ),
          icon: Icon(
            BlocProvider.of<EventCubit>(context).state.showingFavourites
                ? Icons.star
                : Icons.star_border_outlined,
          ),
        ),
        IconButton(
          onPressed: () {
            BlocProvider.of<EventCubit>(context).setOnSearch(true);
          },
          icon: Icon(Icons.search),
        ),
      ],
      title: Row(
        children: [
          Icon(iconList[
              BlocProvider.of<EventCubit>(context).state.page.iconIndex]),
          Expanded(
            child: Text(
              BlocProvider.of<EventCubit>(context).state.page.title,
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
          BlocProvider.of<EventCubit>(context).setOnSearch(false);
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
                  BlocProvider.of<EventCubit>(context).acceptForward(
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
          BlocProvider.of<EventCubit>(context).setSelectionMode(false);
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
          _controller.text = BlocProvider.of<EventCubit>(context)
              .state
              .selected
              .first
              .description;
          _focusNode.requestFocus();
          BlocProvider.of<EventCubit>(context).setOnEdit(true);
        },
        icon: Icon(Icons.edit_outlined),
      );
    }

    IconButton _deleteButton() {
      return IconButton(
        onPressed: () {
          BlocProvider.of<EventCubit>(context).deleteEvents();
          BlocProvider.of<EventCubit>(context).setSelectionMode(false);
        },
        icon: Icon(Icons.delete_outline),
      );
    }

    IconButton _favouritesButton() {
      return IconButton(
        onPressed: () {
          BlocProvider.of<EventCubit>(context).addToFavourites();
          BlocProvider.of<EventCubit>(context).setSelectionMode(false);
        },
        icon: Icon(
          BlocProvider.of<EventCubit>(context).state.areAllFavourites()
              ? Icons.star
              : Icons.star_border_outlined,
        ),
      );
    }

    IconButton _copyButton() {
      return IconButton(
        onPressed: () {
          FlutterClipboard.copy(BlocProvider.of<EventCubit>(context)
              .state
              .selected
              .first
              .description);
          BlocProvider.of<EventCubit>(context).setSelectionMode(false);
        },
        icon: Icon(Icons.copy),
      );
    }

    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      title: Text(
        BlocProvider.of<EventCubit>(context).state.selected.length.toString(),
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
        if (BlocProvider.of<EventCubit>(context).state.selected.length == 1)
          _editButton(),
        _deleteButton(),
        _favouritesButton(),
        if (BlocProvider.of<EventCubit>(context).state.selected.length == 1)
          _copyButton(),
      ],
    );
  }

  Widget get _listView {
    final _allowed = BlocProvider.of<EventCubit>(context).state.isSearching
        ? BlocProvider.of<EventCubit>(context)
            .state
            .events
            .where((element) => element.description.contains(_controller.text))
            .toList()
        : BlocProvider.of<EventCubit>(context).state.events;

    final _displayed =
        BlocProvider.of<EventCubit>(context).state.showingFavourites
            ? _allowed.where((event) => event.isFavourite).toList()
            : _allowed;

    return EventMessageList(
      _displayed,
      BlocProvider.of<EventCubit>(context).state.isDateCentered,
      BlocProvider.of<EventCubit>(context).state.isRightToLeft,
      builder: (event) {
        return EventMessageTile(
          event,
          BlocProvider.of<EventCubit>(context).state.isRightToLeft,
          true,
          BlocProvider.of<EventCubit>(context).state.selected.contains(event),
          onTap: () {
            if (BlocProvider.of<EventCubit>(context).state.isOnSelectionMode) {
              BlocProvider.of<EventCubit>(context).selectEvent(event);
            }
          },
          onLongPress: () {
            BlocProvider.of<EventCubit>(context).setSelectionMode(true);
            BlocProvider.of<EventCubit>(context).selectEvent(event);
          },
          onHashTap: (text) {
            BlocProvider.of<EventCubit>(context).setOnSearch(true);
            _controller.text = text;
          },
          onDelete: (event) =>
              BlocProvider.of<EventCubit>(context).deleteSingle(event),
          onEdit: (event) {
            BlocProvider.of<EventCubit>(context).setSelectionMode(true);
            BlocProvider.of<EventCubit>(context).selectEvent(event);
            _controller.text = event.description;
            _focusNode.requestFocus();
            BlocProvider.of<EventCubit>(context).setOnEdit(true);
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
                    BlocProvider.of<EventCubit>(context)
                        .addEventFromResource(File(image.path));
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
                    BlocProvider.of<EventCubit>(this.context)
                        .addEventFromResource(File(image.path));
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
        if (BlocProvider.of<EventCubit>(context).state.canSelectImage) {
          _showBottomSheet();
        } else {
          if (BlocProvider.of<EventCubit>(context).state.isOnEdit) {
            BlocProvider.of<EventCubit>(context).editEvent(_controller.text,
                BlocProvider.of<EventCubit>(context).state.selected.first);
          } else {
            BlocProvider.of<EventCubit>(context).addEvent(
              _controller.text,
            );
          }
          _controller.clear();
          BlocProvider.of<EventCubit>(context).setCanSelectImage(true);
        }
      },
      child: Icon(
        BlocProvider.of<EventCubit>(context).state.canSelectImage
            ? Icons.photo_camera
            : BlocProvider.of<EventCubit>(context).state.isOnEdit
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
        if (BlocProvider.of<EventCubit>(context).state.isSearching) {
          BlocProvider.of<EventCubit>(context).setOnSearch(true);
        } else {
          BlocProvider.of<EventCubit>(context).setCanSelectImage(text.isEmpty);
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
                    BlocProvider.of<EventCubit>(context).selectIcon(index);
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
              if (!BlocProvider.of<EventCubit>(context).state.isSearching)
                IconButton(
                  icon: Icon(
                    BlocProvider.of<EventCubit>(context)
                                .state
                                .selectedIconIndex ==
                            0
                        ? Icons.insert_emoticon
                        : eventIconList[BlocProvider.of<EventCubit>(context)
                            .state
                            .selectedIconIndex],
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
              if (!BlocProvider.of<EventCubit>(context).state.isSearching)
                _floatingActionButton,
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
      cubit: BlocProvider.of<EventCubit>(context),
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
                alignment:
                    BlocProvider.of<EventCubit>(context).state.isRightToLeft
                        ? Alignment.topLeft
                        : Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(2))),
                    child: BlocProvider.of<EventCubit>(context)
                            .state
                            .isDateSelected
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.close,
                                size: 17,
                              ),
                              Text(
                                DateFormat('dd.MM.yyyy HH:mm').format(
                                    BlocProvider.of<EventCubit>(context)
                                        .state
                                        .date),
                              ),
                            ],
                          )
                        : Text('Set date'),
                    onPressed: () async {
                      if (BlocProvider.of<EventCubit>(context)
                          .state
                          .isDateSelected) {
                        BlocProvider.of<EventCubit>(context).setDate(null);
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
                            BlocProvider.of<EventCubit>(context).setDate(date);
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
