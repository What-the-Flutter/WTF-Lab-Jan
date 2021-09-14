import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../color_theme.dart';
import '../icons.dart';
import '../main_page/pages_cubit.dart';
import '../page.dart';
import 'messages_cubit.dart';
import 'messages_state.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key? key, this.title, this.page}) : super(key: key);

  final String? title;
  final JournalPage? page;

  @override
  _MessagePageState createState() => _MessagePageState(page: page);
}

class _MessagePageState extends State<MessagePage> {
  _MessagePageState({required this.page}) {
    cubit = MessageCubit(MessagesState(page!.events));
  }

  final JournalPage? page;
  final controller = TextEditingController();
  final _focusNode = FocusNode();

  MessageCubit? cubit;

  PreferredSizeWidget get _infoAppBar {
    return AppBar(
      backgroundColor: ColorThemeData.of(context)!.accentColor,
      actions: [
        IconButton(
          onPressed: () => cubit!.showFavourites(!cubit!.state.showingFavourites),
          icon: Icon(
            cubit!.state.showingFavourites ? Icons.star : Icons.star_border_outlined,
          ),
        ),
        IconButton(
          onPressed: () => cubit!.setOnSearch(true),
          icon: const Icon(Icons.search),
        ),
      ],
      title: Row(
        children: [
          Icon(iconList[page!.iconIndex]),
          Expanded(
            child: Text(
              page!.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget get _searchAppBar {
    return AppBar(
      backgroundColor: ColorThemeData.of(context)!.accentColor,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          cubit!.setOnSearch(false);
          controller.clear();
        },
      ),
      title: const Expanded(
        child: Text(
          'Searching',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
                  BlocProvider.of<PagesCubit>(context).acceptForward(
                      BlocProvider.of<PagesCubit>(context).state[index], cubit!.state.selected);
                  cubit!.deleteEvents();
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(35),
                    ),
                    color: ColorThemeData.of(context)!.accentColor,
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Icon(
                        iconList[BlocProvider.of<PagesCubit>(context).state[index].iconIndex],
                        color: ColorThemeData.of(context)!.accentTextColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          BlocProvider.of<PagesCubit>(context).state[index].title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorThemeData.of(context)!.accentTextColor,
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
        backgroundColor: ColorThemeData.of(context)!.mainColor,
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
          cubit!.setSelectionMode(false);
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
          controller.text = cubit!.state.selected.first.description;
          _focusNode.requestFocus();
          cubit!.setOnEdit(true);
        },
        icon: const Icon(Icons.edit_outlined),
      );
    }

    IconButton _deleteButton() {
      return IconButton(
        onPressed: () {
          cubit!.deleteEvents();
          cubit!.setSelectionMode(false);
        },
        icon: const Icon(Icons.delete_outline),
      );
    }

    IconButton _favouritesButton() {
      return IconButton(
        onPressed: () {
          cubit!.addToFavourites();
          cubit!.setSelectionMode(false);
        },
        icon: Icon(
          cubit!.state.areAllFavourites() ? Icons.star : Icons.star_border_outlined,
        ),
      );
    }

    IconButton _copyButton() {
      return IconButton(
        onPressed: () {
          FlutterClipboard.copy(cubit!.state.selected.first.description);
          cubit!.setSelectionMode(false);
        },
        icon: const Icon(Icons.copy),
      );
    }

    return AppBar(
      backgroundColor: ColorThemeData.of(context)!.accentColor,
      title: Text(cubit!.state.selected.length.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold)),
      leading: _closeButton(),
      actions: [
        _forwardButton(),
        if (cubit!.state.selected.length == 1) _editButton(),
        _deleteButton(),
        _favouritesButton(),
        if (cubit!.state.selected.length == 1) _copyButton(),
      ],
    );
  }

  Widget get _listView {
    final _allowed = cubit!.state.isSearching
        ? page!.events.where((element) => element.description.contains(controller.text)).toList()
        : page!.events;

    final _displayed = cubit!.state.showingFavourites
        ? _allowed.where((event) => event.isFavourite).toList()
        : _allowed;

    if (_displayed.isNotEmpty) {
      return ListView.builder(
        reverse: true,
        itemCount: _displayed.length,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return _listItem(_displayed[index], index);
        },
      );
    } else {
      return Center(
        child: Text(
          'No events yet...',
          style: TextStyle(
            color: ColorThemeData.of(context)!.mainTextColor.withOpacity(0.5),
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
            color: ColorThemeData.of(context)!.accentTextColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              eventStringList[event.iconIndex],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorThemeData.of(context)!.accentTextColor,
              ),
            ),
          )
        ],
      );
    }

    Widget _content(Event event) {
      return Text(
        event.description,
        style: TextStyle(
          fontSize: 15,
          color: ColorThemeData.of(context)!.accentTextColor,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        cubit!.selectEvent(event);
      },
      onLongPress: () {
        cubit!.setSelectionMode(true);
        cubit!.selectEvent(event);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: cubit!.state.selected.contains(event)
              ? ColorThemeData.of(context)!.accentLightColor
              : ColorThemeData.of(context)!.accentColor,
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
                  DateFormat('dd.MM.yyyy HH:mm').format(event.creationTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorThemeData.of(context)!.accentTextColor,
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
    return FloatingActionButton(
      onPressed: () {
        if (controller.text.isNotEmpty) {
          if (cubit!.state.isOnEdit) {
            cubit!.editEvent(controller.text);
          } else {
            cubit!.addEvent(Event(page!.id, controller.text, cubit!.state.selectedIconIndex));
          }
          controller.clear();
        }
      },
      child: Icon(
        cubit!.state.isOnEdit ? Icons.check : Icons.send,
        color: ColorThemeData.of(context)!.accentTextColor,
        size: 18,
      ),
      backgroundColor: ColorThemeData.of(context)!.accentColor,
      elevation: 0,
    );
  }

  Widget get _textField {
    return TextField(
      style: TextStyle(
        color: ColorThemeData.of(context)!.mainTextColor,
      ),
      onChanged: (text) {
        if (cubit!.state.isSearching) {
          cubit!.setOnSearch(true);
        }
      },
      controller: controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Write event description...',
        hintStyle: TextStyle(
          color: ColorThemeData.of(context)!.mainTextColor.withOpacity(0.5),
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
                    cubit!.selectIcon(index);
                    Navigator.pop(context, index);
                  },
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: ColorThemeData.of(context)!.accentColor,
                          foregroundColor: ColorThemeData.of(context)!.accentTextColor,
                          child: Icon(eventIconList[index]),
                        ),
                        Expanded(
                          child: Text(
                            eventStringList[index],
                            style: TextStyle(
                              color: ColorThemeData.of(context)!.mainTextColor,
                              fontSize: 12,
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
        backgroundColor: ColorThemeData.of(context)!.mainColor,
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
            color: ColorThemeData.of(context)!.mainColor,
            child: Row(
              children: <Widget>[
                if (!cubit!.state.isSearching)
                  IconButton(
                    icon: Icon(
                      cubit!.state.selectedIconIndex == 0
                          ? Icons.insert_emoticon
                          : eventIconList[cubit!.state.selectedIconIndex],
                      color: ColorThemeData.of(context)!.accentColor,
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
                if (!cubit!.state.isSearching) _floatingActionButton,
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
          backgroundColor: ColorThemeData.of(context)!.mainColor,
          appBar: cubit!.state.isOnSelectionMode
              ? _editAppBar
              : cubit!.state.isSearching
                  ? _searchAppBar
                  : _infoAppBar,
          body: _body,
        );
      },
    );
  }
}
