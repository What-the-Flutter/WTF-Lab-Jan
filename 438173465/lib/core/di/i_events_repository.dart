import '../models/event.dart';
import '../models/event_type.dart';

abstract class IEventsRepository {
  Future<List<EventType>> fetchEventTypeList();

  Future<List<Event>> fetchEventsList(EventType eventType);

  Future<Event> upsertEvent(Event event);

  Future<EventType> upsertEventType(EventType eventType);

  Future<Event> deleteEvent(Event event);

  Future<EventType> deleteEventType(EventType eventType);
}
