import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../constants/icon_map.dart';
import '../../../../core/models/event_type.dart';
import '../../../../core/services/db/db_helper.dart';
import '../../../shared/utils/date_formatter.dart';
import '../screens/event_screen.dart';
import '../screens/events_type_add_screen.dart';

Widget eventTypeList() {
  return StatefulBuilder(
    builder: (context, mystate) {
      return Expanded(
        child: FutureBuilder<List<EventType>>(
          future: DBProvider.db.fetchEventTypeList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final item = snapshot.data[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Icon(
                        iconMap[item.icon],
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.grey,
                    ),
                    title: Text(
                      item.title,
                    ),
                    subtitle: Text(
                      item.lastEvent.message,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    hoverColor: Colors.redAccent,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        item.lastEvent.date == null
                            ? SizedBox()
                            : Text(
                                '${DateFormat.jm().format(item.lastEvent.date)}'),
                        item.pin == 1
                            ? Icon(
                                Icons.push_pin_sharp,
                                size: 20,
                              )
                            : SizedBox(),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        EventScreen.routeName,
                        arguments: item,
                      ).whenComplete(() => mystate(() {}));
                    },
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 290,
                            child: _bottomModalSheet(
                              mystate,
                              context,
                              item,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: const Text(
                  'No events',
                ),
              );
            } else {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
          },
        ),
      );
    },
  );
}

Column _bottomModalSheet(
  void Function(void Function()) mystate,
  BuildContext context,
  EventType item,
) {
  return Column(
    children: [
      ListTile(
        leading: Icon(
          Icons.info,
          color: Colors.cyanAccent,
        ),
        title: const Text(
          'Info',
        ),
        onTap: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      child: Icon(
                        iconMap[item.icon],
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    )
                  ],
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                        'Created',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${dateFormatter(item.date)} at '
                        '${DateFormat.jm().format(item.date)}',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Lastest Event',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.lastEvent.date == null
                            ? 'No events'
                            : '${dateFormatter(item.lastEvent.date)} at ${DateFormat.jm().format(item.lastEvent.date)}',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('ok'),
                  )
                ],
              );
            },
          );
          //print(item.title);
        },
      ),
      ListTile(
        leading: Icon(
          Icons.push_pin_outlined,
          color: Colors.green,
        ),
        title: const Text('Pin/Unpin Page'),
        onTap: () {
          mystate(
            () {
              item.pin == 1 ? item.pin = 0 : item.pin = 1;
              DBProvider.db.upsertEventType(item);
              Navigator.pop(context);
            },
          );
        },
      ),
      ListTile(
        leading: Icon(
          Icons.archive,
          color: Colors.yellow,
        ),
        title: const Text('Archive Page'),
        onTap: () {
          Navigator.pop(context);
          print(item.title);
        },
      ),
      ListTile(
        leading: Icon(
          Icons.create_sharp,
          color: Colors.cyan,
        ),
        title: const Text('Edit page'),
        onTap: () {
          Navigator.pushNamed(
            context,
            EventTypeAdd.routeName,
            arguments: item,
          ).whenComplete(
            () {
              mystate(() {});
              Navigator.pop(context);
            },
          );
        },
      ),
      ListTile(
        leading: Icon(
          Icons.delete,
          color: Colors.red,
        ),
        title: const Text('Delete page'),
        onTap: () {
          mystate(() {
            DBProvider.db.deleteEventType(item);
          });
          Navigator.pop(context);
          print(item.title);
        },
      )
    ],
  );
}
