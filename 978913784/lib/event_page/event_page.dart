import 'package:chat_journal/home_page/pages_bloc.dart';
import 'package:chat_journal/home_page/pages_event.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../app_theme.dart';
import '../icon_list.dart';
import '../page.dart';
import 'events_bloc.dart';
import 'events_event.dart';
import 'events_state.dart';

class EventPage extends StatefulWidget {
  EventPage({Key key, this.title, this.page}) : super(key: key);

  final String title;
  final JournalPage page;

  @override
  _EventPageState createState() => _EventPageState(page: page);
}

class _EventPageState extends State<EventPage> {
  _EventPageState({@required this.page}) {
    bloc = EventsBloc(EventsState(page.events));
  }

  final JournalPage page;
  final controller = TextEditingController();
  final _focusNode = FocusNode();

  EventsBloc bloc;

  Widget get _infoAppBar {
    return AppBar(
      backgroundColor: AppThemeData.of(context).accentColor,
      actions: [
        IconButton(
          onPressed: () =>
              bloc.add(ShowFavourites(!bloc.state.showingFavourites)),
          icon: Icon(bloc.state.showingFavourites
              ? Icons.star
              : Icons.star_border_outlined),
        ),
        IconButton(
          onPressed: () {
            bloc.add(SetOnSearch(true));
          },
          icon: Icon(Icons.search),
        ),
      ],
      title: Row(
        children: [
          Icon(page.icon),
          Expanded(
            child: Text(
              page.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _searchAppBar {
    return AppBar(
      backgroundColor: AppThemeData.of(context).accentColor,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          bloc.add(SetOnSearch(false));
          controller.clear();
        },
      ),
      title: Expanded(
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

  Widget get _editAppBar {
    Widget _iconDialog() {
      Widget _content() {
        return Container(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: BlocProvider.of<PagesBloc>(context).state.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  BlocProvider.of<PagesBloc>(context).add(ForwardAccepted(
                      BlocProvider.of<PagesBloc>(context).state[index],
                      bloc.state.selected));
                  bloc.add(EventsDeleted());
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: AppThemeData.of(context).accentColor,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Icon(
                        BlocProvider.of<PagesBloc>(context).state[index].icon,
                        color: AppThemeData.of(context).accentTextColor,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          BlocProvider.of<PagesBloc>(context)
                              .state[index]
                              .title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppThemeData.of(context).accentTextColor,
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
        backgroundColor: AppThemeData.of(context).mainColor,
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
          controller.clear();
          bloc.add(SetSelectionMode(false));
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
          controller.text = bloc.state.selected.first.description;
          _focusNode.requestFocus();
          bloc.add(SetOnEdit(true));
        },
        icon: Icon(Icons.edit_outlined),
      );
    }

    IconButton _deleteButton() {
      return IconButton(
        onPressed: () {
          bloc.add(EventsDeleted());
          bloc.add(SetSelectionMode(false));
        },
        icon: Icon(Icons.delete_outline),
      );
    }

    IconButton _favouritesButton() {
      return IconButton(
        onPressed: () {
          bloc.add(AddedToFavourites());
          bloc.add(SetSelectionMode(false));
        },
        icon: Icon(
          bloc.state.areAllFavourites()
              ? Icons.star
              : Icons.star_border_outlined,
        ),
      );
    }

    IconButton _copyButton() {
      return IconButton(
        onPressed: () {
          FlutterClipboard.copy(bloc.state.selected.first.description);
          bloc.add(SetSelectionMode(false));
        },
        icon: Icon(Icons.copy),
      );
    }

    return AppBar(
      backgroundColor: AppThemeData.of(context).accentColor,
      title: Text(bloc.state.selected.length.toString(),
          style: TextStyle(fontWeight: FontWeight.bold)),
      leading: _closeButton(),
      actions: [
        _forwardButton(),
        if (bloc.state.selected.length == 1) _editButton(),
        _deleteButton(),
        _favouritesButton(),
        if (bloc.state.selected.length == 1) _copyButton(),
      ],
    );
  }

  Widget get _listView {
    var _allowed = bloc.state.isSearching
        ? page.events
            .where((element) => element.description.contains(controller.text))
            .toList()
        : page.events;

    var _displayed = bloc.state.showingFavourites
        ? _allowed.where((event) => event.isFavourite).toList()
        : _allowed;

    if (_displayed.isNotEmpty) {
      return ListView.builder(
        reverse: true,
        itemCount: _displayed.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return _listItem(_displayed[index], index);
        },
      );
    } else {
      return Center(
        child: Text(
          'No events yet...',
          style: TextStyle(
            color: AppThemeData.of(context).mainTextColor.withOpacity(0.5),
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
            eventIconList[event.selectedIconIndex],
            color: AppThemeData.of(context).accentTextColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              eventStringList[event.selectedIconIndex],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppThemeData.of(context).accentTextColor,
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
          color: AppThemeData.of(context).accentTextColor,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        bloc.add(EventSelected(event));
      },
      onLongPress: () {
        bloc.add(SetSelectionMode(true));
        bloc.add(EventSelected(event));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: bloc.state.selected.contains(event)
              ? AppThemeData.of(context).accentLightColor
              : AppThemeData.of(context).accentColor,
        ),
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.selectedIconIndex != 0) _title(event),
            _content(event),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: event.isFavourite
                      ? Align(
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
                    color: AppThemeData.of(context).accentTextColor,
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
          if (bloc.state.isOnEdit) {
            bloc.add(EventEdited(controller.text));
          } else {
            bloc.add(EventAdded(
                Event(controller.text, bloc.state.selectedIconIndex)));
          }
          controller.clear();
        }
      },
      child: Icon(
        bloc.state.isOnEdit ? Icons.check : Icons.send,
        color: AppThemeData.of(context).accentTextColor,
        size: 18,
      ),
      backgroundColor: AppThemeData.of(context).accentColor,
      elevation: 0,
    );
  }

  Widget get _textField {
    return TextField(
      style: TextStyle(
        color: AppThemeData.of(context).mainTextColor,
      ),
      onChanged: (text) {
        if (bloc.state.isSearching) {
          bloc.add(SetOnSearch(true));
        }
      },
      controller: controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Write event description...',
        hintStyle: TextStyle(
          color: AppThemeData.of(context).mainTextColor.withOpacity(0.5),
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
                    bloc.add(IconSelected(index));
                    Navigator.pop(context, index);
                  },
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppThemeData.of(context).accentColor,
                          foregroundColor:
                              AppThemeData.of(context).accentTextColor,
                          child: Icon(eventIconList[index]),
                        ),
                        Expanded(
                          child: Text(
                            eventStringList[index],
                            style: TextStyle(
                              color: AppThemeData.of(context).mainTextColor,
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
        backgroundColor: AppThemeData.of(context).mainColor,
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
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: AppThemeData.of(context).mainColor,
            child: Row(
              children: <Widget>[
                if (!bloc.state.isSearching)
                  IconButton(
                    icon: Icon(
                      bloc.state.selectedIconIndex == 0
                          ? Icons.insert_emoticon
                          : eventIconList[bloc.state.selectedIconIndex],
                      color: AppThemeData.of(context).accentColor,
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
                if (!bloc.state.isSearching) _floatingActionButton,
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
        cubit: bloc,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppThemeData.of(context).mainColor,
            appBar: state.isOnSelectionMode
                ? _editAppBar
                : state.isSearching
                    ? _searchAppBar
                    : _infoAppBar,
            body: _body,
          );
        });
  }
}
