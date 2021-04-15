import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/event.dart';
import '../../../../core/models/event_type.dart';
import '../../../../core/services/db/db_helper.dart';
import '../../../shared/utils/date_formatter.dart';
import '../../../shared/utils/edit_notification.dart';
import '../../../shared/widgets/pop_up_menu.dart';

Widget eventList({
  EventType eventType,
  TextEditingController textController,
  bool favorite,
}) {
  return Flexible(
    child: StatefulBuilder(
      builder: (context, newState) {
        return FutureBuilder<List<Event>>(
          future: favorite == false
              ? DBProvider.db.fetchEventsList(eventType)
              : DBProvider.db.fetchFavoriteEventsList(eventType),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GroupedListView(
                elements: snapshot.data,
                reverse: true,
                itemBuilder: (context, element) => _listEvents(
                  myState: newState,
                  context: context,
                  event: element,
                  controller: textController,
                ),
                groupBy: (element) => DateTime(
                  element.date.year,
                  element.date.month,
                  element.date.day,
                ),
                groupComparator: (value1, value2) => value2.compareTo(value1),
                order: GroupedListOrder.ASC,
                groupHeaderBuilder: _groupDivider,
              );
            } else if (!snapshot.hasData) {
              return _emptyList(
                eventType: eventType,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    ),
  );
}

Container _listEvents({
  void Function(void Function()) myState,
  BuildContext context,
  Event event,
  TextEditingController controller,
}) {
  return Container(
    padding: EdgeInsets.only(
      left: 14,
      right: 14,
      top: 5,
      bottom: 5,
    ),
    child: PopupMenuButton(
      onSelected: (index) {
        switch (index) {
          case 1:
            Clipboard.setData(ClipboardData(
              text: event.message,
            ));
            break;
          case 2:
            myState(() {
              DBProvider.db.deleteEvent(event);
            });
            break;
          case 3:
            controller.text = event.message;
            EditNotification(
              id: event.id,
              date: event.date,
            )..dispatch(context);
            break;
        }
      },
      initialValue: event.id,
      itemBuilder: (context) => popUpMenu(),
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.message,
                    ),
                    Text(
                      ' ${DateFormat.jm().format(event.date)}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                event.favorite == 0 ? Icons.favorite_outline : Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                myState(() {
                  event.favorite == 0 ? event.favorite = 1 : event.favorite = 0;
                  DBProvider.db.upsertEvent(event);
                });
              },
            )
          ],
        ),
      ),
    ),
  );
}

Container _groupDivider(
  Event element,
) {
  return Container(
    padding: EdgeInsets.only(
      left: 14,
      right: 14,
      top: 5,
      bottom: 5,
    ),
    child: Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(7),
            bottomLeft: Radius.circular(7),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Text(
          dateFormatter(
            element.date,
          ),
        ),
      ),
    ),
  );
}

Align _emptyList({
  EventType eventType,
}) {
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: const EdgeInsets.all(40.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 300,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.orange[100],
          ),
          padding: EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  'This is the page where you can track everything about "${eventType.title}"\n\n',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text:
                      'Add you first event to "${eventType.title}" page by entering some text '
                      'in the text box below and hitting the send button. Long tap he send'
                      ' button to align the event '
                      'in the opposite direction. Tap on the bookmark icon on the top right corner '
                      'to show the bookmarked events only',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
