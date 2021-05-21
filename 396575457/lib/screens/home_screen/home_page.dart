import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/screens_theme.dart';
import '../create_event_screen/create_event_page.dart';
import '../create_new_page_screen/create_new_page.dart';
import 'event.dart';
import 'event_data.dart';

class HomePage extends StatefulWidget {
  final EventData eventsTitlesData;

  HomePage({this.eventsTitlesData});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EventData eventsTitlesData;
  int _sectionIndex = 0;
  Event _newEvent;
  int _selectEventIndex;
  var _noteBoxHeight = 0.0;

  @override
  void initState() {
    if (widget.eventsTitlesData == null) {
      eventsTitlesData = EventData();
    } else {
      eventsTitlesData = widget.eventsTitlesData;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bottomBar = BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.dialpad,
          ),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.timeline,
          ),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.explore,
          ),
          label: 'Explore',
        ),
      ],
      currentIndex: _sectionIndex,
      onTap: (index) {
        setState(
          () {
            _sectionIndex = index;
          },
        );
      },
    );

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 2, color: Colors.white),
                  ),
                ),
                child: Center(
                  child: RaisedButton(
                    onPressed: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.android),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        Text('Questionnaire Bot')
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: Center(
            child: Text('Home'),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ),
              onPressed: null),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.invert_colors, color: Colors.white),
              onPressed: () {
                final provider = ScreensThemeState.of(context);
                provider.changeTheme();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _fetchTitlesData(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: AnimatedContainer(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  color: Theme.of(context).cardColor,
                  width: double.infinity,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        title: Text('Edit Page'),
                        onTap: null,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: Text('Delete Page'),
                        onTap: () {
                          setState(
                            () {
                              eventsTitlesData
                                  .removeEventByIndex(_selectEventIndex);
                              _selectEventIndex = null;
                              _noteBoxHeight = 0.0;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                height: _noteBoxHeight,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateNewPage((value) {
                  return _newEvent = value;
                }),
              ),
            );
            _fetchTitlesData();
          },
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        bottomNavigationBar: bottomBar,
      ),
    );
  }

  ListView _fetchTitlesData() {
    if (_newEvent != null) {
      setState(
        () {
          eventsTitlesData.putAlreadyCreateEvent(_newEvent);
          _newEvent = null;
        },
      );
    }
    return _eventsTitleList();
  }

  ListView _eventsTitleList() {
    return ListView.builder(
      itemCount: eventsTitlesData.size,
      itemBuilder: (context, i) {
        return Container(
          margin: EdgeInsets.only(
            left: 7,
            right: 7,
          ),
          child: RaisedButton(
            color: i != _selectEventIndex
                ? Colors.white
                : Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventPage(
                    eventTitle: eventsTitlesData.getTitleByIndex(i),
                    isEventSelected: false,
                    selectedMessage: null,
                    dataEvent: eventsTitlesData.getEventByIndex(i),
                  ),
                ),
              );
            },
            onLongPress: () {
              setState(() {
                _selectEventIndex = i;
                _noteBoxHeight = 112.0;
              });
            },
            child: Row(
              children: [
                CircleAvatar(
                  child: eventsTitlesData.getEventByIndex(i).circleAvatar,
                  radius: 15,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Text(
                  eventsTitlesData.eventsList[i].title,
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
