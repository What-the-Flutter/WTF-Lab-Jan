import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/icons.dart';
import '../../../entity/page.dart';
import '../../../widgets/message_list.dart';
import '../../../widgets/message_tile.dart';
import '../../settings_page/settings_cubit.dart';
import '../pages_cubit.dart';
import 'messages_cubit.dart';

class MessagePage extends StatefulWidget {
  MessagePage(this.page, {Key? key}) : super(key: key);

  final JournalPage page;

  @override
  _MessagePageState createState() => _MessagePageState(page);
}

class _MessagePageState extends State<MessagePage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  final JournalPage page;

  _MessagePageState(this.page);

  @override
  void initState() {
    BlocProvider.of<MessageCubit>(context).initialize(page);
    super.initState();
  }

  PreferredSizeWidget get _infoAppBar {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).accentIconTheme,
      actions: [
        IconButton(
          onPressed: () => BlocProvider.of<MessageCubit>(context).showFavourites(
            !BlocProvider.of<MessageCubit>(context).state.showingFavourites,
          ),
          icon: Icon(
            BlocProvider.of<MessageCubit>(context).state.showingFavourites
                ? Icons.star
                : Icons.star_border_outlined,
          ),
        ),
        IconButton(
          onPressed: () => BlocProvider.of<MessageCubit>(context).setOnSearch(true),
          icon: const Icon(Icons.search),
        ),
      ],
      title: Row(
        children: [
          Icon(iconList[BlocProvider.of<MessageCubit>(context).state.page.iconIndex]),
          Expanded(
            child: Text(
              BlocProvider.of<MessageCubit>(context).state.page.title,
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
          BlocProvider.of<MessageCubit>(context).setOnSearch(false);
          _controller.clear();
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
                  BlocProvider.of<MessageCubit>(context).acceptForward(
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
          _controller.clear();
          BlocProvider.of<MessageCubit>(context).setSelectionMode(false);
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
          _controller.text =
              BlocProvider.of<MessageCubit>(context).state.selected.first.description;
          _focusNode.requestFocus();
          BlocProvider.of<MessageCubit>(context).setOnEdit(true);
        },
        icon: const Icon(Icons.edit_outlined),
      );
    }

    IconButton _deleteButton() {
      return IconButton(
        onPressed: () {
          BlocProvider.of<MessageCubit>(context).deleteEvents();
          BlocProvider.of<MessageCubit>(context).setSelectionMode(false);
        },
        icon: const Icon(Icons.delete_outline),
      );
    }

    IconButton _favouritesButton() {
      return IconButton(
        onPressed: () {
          BlocProvider.of<MessageCubit>(context).addToFavourites();
          BlocProvider.of<MessageCubit>(context).setSelectionMode(false);
        },
        icon: Icon(
          BlocProvider.of<MessageCubit>(context).state.areAllFavourites()
              ? Icons.star
              : Icons.star_border_outlined,
        ),
      );
    }

    IconButton _copyButton() {
      return IconButton(
        onPressed: () {
          FlutterClipboard.copy(
              BlocProvider.of<MessageCubit>(context).state.selected.first.description);
          BlocProvider.of<MessageCubit>(context).setSelectionMode(false);
        },
        icon: const Icon(Icons.copy),
      );
    }

    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      title: Text(
        BlocProvider.of<MessageCubit>(context).state.selected.length.toString(),
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
        if (BlocProvider.of<MessageCubit>(context).state.selected.length == 1) _editButton(),
        _deleteButton(),
        _favouritesButton(),
        if (BlocProvider.of<MessageCubit>(context).state.selected.length == 1) _copyButton(),
      ],
    );
  }

  Widget get _listView {
    final _allowed = BlocProvider.of<MessageCubit>(context).state.isSearching
        ? BlocProvider.of<MessageCubit>(context)
            .state
            .events
            .where((element) => element.description.contains(_controller.text))
            .toList()
        : BlocProvider.of<MessageCubit>(context).state.events;

    final _displayed = BlocProvider.of<MessageCubit>(context).state.showingFavourites
        ? _allowed.where((event) => event.isFavourite).toList()
        : _allowed;

    return MessageList(
      _displayed,
      BlocProvider.of<MessageCubit>(context).state.isDateCentered,
      BlocProvider.of<MessageCubit>(context).state.isRightToLeft,
      builder: (event) {
        return MessageTile(
          event,
          BlocProvider.of<MessageCubit>(context).state.isRightToLeft,
          true,
          BlocProvider.of<MessageCubit>(context).state.selected.contains(event),
          onTap: () {
            if (BlocProvider.of<MessageCubit>(context).state.isOnSelectionMode) {
              BlocProvider.of<MessageCubit>(context).selectEvent(event);
            }
          },
          onLongPress: () {
            BlocProvider.of<MessageCubit>(context).setSelectionMode(true);
            BlocProvider.of<MessageCubit>(context).selectEvent(event);
          },
          onHashTap: (text) {
            BlocProvider.of<MessageCubit>(context).setOnSearch(true);
            _controller.text = text;
          },
          onDelete: (event) => BlocProvider.of<MessageCubit>(context).deleteSingle(event),
          onEdit: (event) {
            BlocProvider.of<MessageCubit>(context).setSelectionMode(true);
            BlocProvider.of<MessageCubit>(context).selectEvent(event);
            _controller.text = event.description;
            _focusNode.requestFocus();
            BlocProvider.of<MessageCubit>(context).setOnEdit(true);
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
                    BlocProvider.of<MessageCubit>(context).addEventFromResource(File(image.path));
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
                    BlocProvider.of<MessageCubit>(context).addEventFromResource(File(image.path));
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
        if (BlocProvider.of<MessageCubit>(context).state.canSelectImage) {
          _showBottomSheet();
        } else {
          if (BlocProvider.of<MessageCubit>(context).state.isOnEdit) {
            BlocProvider.of<MessageCubit>(context).editEvent(
                _controller.text, BlocProvider.of<MessageCubit>(context).state.selected.first);
          } else {
            BlocProvider.of<MessageCubit>(context).addEvent(
              _controller.text,
            );
          }
          _controller.clear();
          BlocProvider.of<MessageCubit>(context).setCanSelectImage(true);
        }
      },
      child: Icon(
        BlocProvider.of<MessageCubit>(context).state.canSelectImage
            ? Icons.photo_camera
            : BlocProvider.of<MessageCubit>(context).state.isOnEdit
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
        if (BlocProvider.of<MessageCubit>(context).state.isSearching) {
          BlocProvider.of<MessageCubit>(context).setOnSearch(true);
        } else {
          BlocProvider.of<MessageCubit>(context).setCanSelectImage(text.isEmpty);
        }
      },
      controller: _controller,
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
                    BlocProvider.of<MessageCubit>(context).selectIcon(index);
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
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.2),
              ),
            ),
          ),
          padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
          height: 60,
          width: double.infinity,
          child: Row(
            children: <Widget>[
              if (!BlocProvider.of<MessageCubit>(context).state.isSearching)
                IconButton(
                  icon: Icon(
                    BlocProvider.of<MessageCubit>(context).state.selectedIconIndex == 0
                        ? Icons.insert_emoticon
                        : eventIconList[
                            BlocProvider.of<MessageCubit>(context).state.selectedIconIndex],
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
              if (!BlocProvider.of<MessageCubit>(context).state.isSearching) _floatingActionButton,
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
      bloc: BlocProvider.of<MessageCubit>(context),
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: BlocProvider.of<MessageCubit>(context).state.isOnSelectionMode
              ? _editAppBar
              : BlocProvider.of<MessageCubit>(context).state.isSearching
                  ? _searchAppBar
                  : _infoAppBar,
          body: Stack(
            children: [
              _body,
              Align(
                alignment: BlocProvider.of<MessageCubit>(context).state.isRightToLeft
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.all(2))),
                    child: BlocProvider.of<MessageCubit>(context).state.isDateSelected
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.close,
                                size: 17,
                              ),
                              Text(
                                DateFormat('dd.MM.yyyy HH:mm')
                                    .format(BlocProvider.of<MessageCubit>(context).state.date),
                              ),
                            ],
                          )
                        : const Text('Set date'),
                    onPressed: () async {
                      if (BlocProvider.of<MessageCubit>(context).state.isDateSelected) {
                        BlocProvider.of<MessageCubit>(context).setDate(null);
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
                            BlocProvider.of<MessageCubit>(context).setDate(date);
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
