import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'color_theme.dart';
import 'page.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key? key, this.title, this.page}) : super(key: key);

  final String? title;
  final JournalPage? page;

  @override
  _MessagePageState createState() => _MessagePageState(page: page);
}

class _MessagePageState extends State<MessagePage> {
  _MessagePageState({required this.page});

  final JournalPage? page;
  final controller = TextEditingController();
  final _focusNode = FocusNode();

  Set<int> selected = {};
  bool isOnEdit = false;
  bool isOnSelectionMode = false;
  bool showingFavourites = false;

  PreferredSizeWidget get _infoAppBar {
    return AppBar(
      backgroundColor: ColorThemeData.of(context)!.accentColor,
      actions: [
        IconButton(
          onPressed: () => setState(() {
            showingFavourites = !showingFavourites;
          }),
          icon: Icon(showingFavourites ? Icons.star : Icons.star_border_outlined),
        ),
      ],
      title: Wrap(
        children: [
          Icon(page!.icon),
          Text(
            page!.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget get _editAppBar {
    bool _areAllFavourites() {
      for (var index in selected) {
        if (!page!.events[index].isFavourite) {
          return false;
        }
      }
      return true;
    }

    void _cancelSelection() {
      selected.clear();
      isOnSelectionMode = false;
    }

    IconButton _closeButton() {
      return IconButton(
        onPressed: () => setState(() {
          controller.clear();
          _cancelSelection();
        }),
        icon: const Icon(Icons.clear),
      );
    }

    IconButton _editButton() {
      return IconButton(
        onPressed: () {
          setState(() {
            controller.text = page!.events[selected.first].description;
            _focusNode.requestFocus();
            isOnEdit = true;
          });
        },
        icon: const Icon(Icons.edit_outlined),
      );
    }

    IconButton _deleteButton() {
      return IconButton(
        onPressed: () {
          setState(() {
            var sorted = selected.toList()..sort((a, b) => b.compareTo(a));
            for (var index in sorted) {
              page!.events.removeAt(index);
            }
            _cancelSelection();
          });
        },
        icon: const Icon(Icons.delete_outline),
      );
    }

    IconButton _favouritesButton() {
      final areAllFavourites = _areAllFavourites();

      return IconButton(
        onPressed: () {
          setState(() {
            for (var index in selected) {
              if (areAllFavourites) {
                page!.events[index].isFavourite = false;
              } else {
                page!.events[index].isFavourite = true;
              }
            }
            _cancelSelection();
          });
        },
        icon: Icon(
          areAllFavourites ? Icons.star : Icons.star_border_outlined,
        ),
      );
    }

    IconButton _copyButton() {
      return IconButton(
        onPressed: () {
          setState(() {
            FlutterClipboard.copy(page!.events[selected.first].description);
            _cancelSelection();
          });
        },
        icon: const Icon(Icons.copy),
      );
    }

    return AppBar(
      backgroundColor: ColorThemeData.of(context)!.accentColor,
      title: Text(selected.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
      leading: _closeButton(),
      actions: [
        if (selected.length == 1) _editButton(),
        _deleteButton(),
        _favouritesButton(),
        if (selected.length == 1) _copyButton(),
      ],
    );
  }

  Widget get _listView {
    var _displayed = showingFavourites
        ? page!.events.where((event) => event.isFavourite).toList()
        : page!.events;

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
        if (isOnSelectionMode) {
          setState(() => _select(index));
        }
      },
      onLongPress: () {
        setState(() {
          isOnSelectionMode = true;
          _select(index);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected.contains(index)
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

  Widget get _floatingActionButton => FloatingActionButton(
        onPressed: () {
          if (controller.text.isNotEmpty) {
            if (isOnEdit) {
              page!.events[selected.first].description = controller.text;
              setState(() {
                isOnEdit = false;
                isOnSelectionMode = false;
                selected.clear();
                controller.clear();
              });
            } else {
              setState(() {
                page!.addEvent(Event(controller.text));
                controller.clear();
              });
            }
          }
        },
        child: Icon(
          isOnEdit ? Icons.check : Icons.send,
          color: ColorThemeData.of(context)!.accentTextColor,
          size: 18,
        ),
        backgroundColor: ColorThemeData.of(context)!.accentColor,
        elevation: 0,
      );

  Widget get _textField => TextField(
        style: TextStyle(
          color: ColorThemeData.of(context)!.mainTextColor,
        ),
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

  Widget get _body => Column(
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
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: _textField,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  _floatingActionButton,
                ],
              ),
            ),
          ),
        ],
      );

  @override
  void dispose() {
    controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return applyTheme(
      child: Scaffold(
        backgroundColor: ColorThemeData.of(context)!.mainColor,
        appBar: isOnSelectionMode ? _editAppBar : _infoAppBar,
        body: _body,
      ),
    );
  }

  void _select(int index) {
    if (selected.contains(index)) {
      selected.remove(index);
    } else {
      selected.add(index);
    }
    if (isOnEdit && selected.length != 1) {
      isOnEdit = false;
      controller.clear();
    }
    if (selected.isEmpty) {
      isOnSelectionMode = false;
    }
  }
}
