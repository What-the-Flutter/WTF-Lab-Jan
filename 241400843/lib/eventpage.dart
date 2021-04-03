import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class Notes {
  IconData notesIcon;
  String notesTitle;
  String notesSubtitle;

  Notes(this.notesIcon, this.notesTitle, this.notesSubtitle);
}

List<Notes> notes = [
  Notes(Icons.airport_shuttle, 'First ', 'Something about fisrt'),
  Notes(Icons.airplanemode_active, 'Second ', 'Something about second'),
  Notes(Icons.bike_scooter, 'Third', 'Something about third'),
];

class _EventPageState extends State<EventPage> {
  TextEditingController inputcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Something'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _eventPageCard,
          // child: ListView.builder(
          //   scrollDirection: Axis.vertical,
          //   itemCount: events.length + 1,
          //   itemBuilder: () {
          //     // if (index == 0) {
          //        _eventPageCard;
          //     // }
          //     // events.forEach((element) {
          //     //   return events;
          //     // });
          //   },
          // ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child:
          //Row(
          // children: [
          IconButton(
            icon: Icon(
              Icons.bubble_chart,
            ),
            onPressed: () {},
          ),
          TextField(
            controller: inputcontroller,
            decoration: InputDecoration(
              hintText: 'Enter event',
            ),
            onChanged: (text) {},
          ),
          IconButton(
            icon: Icon(
              Icons.send_sharp,
            ),
            onPressed: () {
              // setState(() {
              //   //     eventpagemessages = inputcontroller.text;
              // });
            },
          ),
          // ],
          // ),
          // ),
        ],
      ),
    );
  }

  Card get _eventPageCard {
    return Card(
        margin: EdgeInsets.all(5.0),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Text(
                'This is page where you can track everything about "Something"',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Text(
                'Text your first event and tap to send it here',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }
}

class EventPageMessages {
  String eventsDescription;

  EventPageMessages(this.eventsDescription);
}

List<EventPageMessages> events = [];

class CreateNewEvent {
  // List<EventPageMessages> events = List<EventPageMessages>();

  List<EventPageMessages> get getEvents {
    return events;
  }
}
