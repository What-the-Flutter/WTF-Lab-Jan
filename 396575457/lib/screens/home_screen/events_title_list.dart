import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../create_event_screen/create_event_page.dart';
import '../create_event_screen/messages_store.dart';
import 'event_data.dart';

class EventsTitleList extends StatefulWidget {
  final EventData _dataEvent = EventData();

  @override
  _EventsTitleListState createState() => _EventsTitleListState(_dataEvent);
}

class _EventsTitleListState extends State<EventsTitleList> {
  final EventData _dataEvent;

  _EventsTitleListState(this._dataEvent);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _dataEvent.size,
        itemBuilder: (context, i) {
          return Container(
            margin: EdgeInsets.only(
              left: 7,
              right: 7,
            ),
            child: RaisedButton(
              // todo: Ask about button background color
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventPage(
                              eventTitle: _dataEvent.getTitleByIndex(i),
                              isEventSelected: false,
                              selectedMessage: null,
                              data: EventsStore(),
                            )));
              },
              child: Row(
                children: [
                  Icon(Icons.list),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Text(_dataEvent.eventsList[i].title)
                ],
              ),
            ),
          );
        });
  }
}
