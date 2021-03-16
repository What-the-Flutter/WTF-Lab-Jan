import 'package:flutter_wtf/db/i_events_repository.dart';
import 'package:flutter_wtf/models/event.dart';
import 'package:flutter_wtf/models/event_type.dart';

class EventsRepository extends IEventsRepository {
  @override
  List<EventType> getEventType() {

  }

  @override
  List<Event> getEventsList() {}

  @override
  void saveEvent(Event event) {
    // TODO: implement saveEvent
  }

  @override
  void saveEventType(EventType eventType) {
    // TODO: implement saveEventType
  }
}
