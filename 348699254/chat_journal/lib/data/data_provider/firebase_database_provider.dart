import 'package:firebase_database/firebase_database.dart';

import '../model/activity_page.dart';
import '../model/event.dart';

class FirebaseDatabaseProvider {
  final database = FirebaseDatabase.instance.ref();

  final _pageRef = FirebaseDatabase.instance.ref().child('/activity_pages');
  final _eventRef = FirebaseDatabase.instance.ref().child('/events');

  Future<void> insertActivityPage(ActivityPage page) async {
    await _pageRef.child(page.id).push().set(page.toMap());
  }

  Future<void> updateActivityPage(ActivityPage page) async {
    await _pageRef.child(page.id).update(page.toMap());
  }

  Future<void> deleteActivityPage(ActivityPage page) async {
    await _pageRef.child(page.id).remove();
  }

  Future<List<ActivityPage>> fetchActivityPageList() async {
    final activityPageList = <ActivityPage>[];
    final resultList = <dynamic>[];
    final childKeyList = <dynamic>[];
    final childPageKeyList = <dynamic>[];
    final snap = await _pageRef.once();
    for (var childSnapshot in snap.snapshot.children) {
      var childKey = childSnapshot.key;
      childKeyList.add(childKey);
    }
    DatabaseEvent snapPage;
    for (var i = 0; i < childKeyList.length; i++) {
      snapPage = await _pageRef.child(childKeyList[i]).once();
      for (var childSnapshot in snapPage.snapshot.children) {
        var childPageKey = childSnapshot.key;
        childPageKeyList.add(childPageKey);
        resultList.add(snapPage.snapshot.child(childPageKeyList[i]).value);
      }
      final result = resultList[i];
      print(result);
      activityPageList
          .add(ActivityPage.fromMap(Map<String, dynamic>.from(result)));
    }
    return activityPageList;
  }

  Future<void> insertEvent(Event event) async {
    await _eventRef.child(event.id).push().set(event.toMap());
  }

  Future<void> deleteEvent(Event event) async {
    await _eventRef.child(event.id).remove();
  }

  Future<void> updateEvent(Event event) async {
    final snapEvent = await _eventRef.child(event.id).once();
    var childKey = snapEvent.snapshot.key;
    await _eventRef.child(event.id).remove();
    await _eventRef.child(event.id).child(childKey!).update(event.toMap());
  }

  Future<List<Event>> fetchEventList() async {
    final eventList = <Event>[];
    final resultList = <dynamic>[];
    final childKeyList = <dynamic>[];
    final childEventKeyList = <dynamic>[];
    final snap = await _eventRef.once();
    for (var childSnapshot in snap.snapshot.children) {
      var childKey = childSnapshot.key;
      childKeyList.add(childKey);
    }
    DatabaseEvent snapEvent;
    for (var i = 0; i < childKeyList.length; i++) {
      snapEvent = await _eventRef.child(childKeyList[i]).once();
      for (var childSnapshot in snapEvent.snapshot.children) {
        var childEventKey = childSnapshot.key;
        childEventKeyList.add(childEventKey);
        resultList.add(snapEvent.snapshot.child(childEventKeyList[i]).value);
      }
      final result = resultList[i];
      eventList.add(Event.fromMap(Map<String, dynamic>.from(result)));
    }
    return eventList;
  }
}
