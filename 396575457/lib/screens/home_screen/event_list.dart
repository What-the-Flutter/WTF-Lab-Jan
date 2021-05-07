import 'package:diary_in_chat_format_app/screens/home_screen/event_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventsList extends StatefulWidget {
  EventData dataEvent = EventData();

  @override
  _EventsListState createState() => _EventsListState(dataEvent);
}

class _EventsListState extends State<EventsList> {
  EventData dataEvent;

  _EventsListState(this.dataEvent);

  @override
  Widget build(BuildContext context) {
    var eventList = Container(
      child: ListView.builder(
          itemCount: dataEvent.size(),
          itemBuilder: (context, i) {
            return Container(
                margin: EdgeInsets.only(
                  left: 7,
                  right: 7,
                ),
                child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {},
                    child: Row(
                      children: [
                        // will be image later
                        Icon(Icons.list),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Text(dataEvent.receiveEventsList[i].title)
                      ],
                    )));
          }),
    );

    return Container(child: eventList);
  }
}
