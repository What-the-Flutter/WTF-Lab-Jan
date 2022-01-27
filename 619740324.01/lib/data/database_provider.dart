import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../event.dart';
import '../note.dart';

class FirebaseFailure implements Exception {
  FirebaseFailure(this.message);

  final String message;

  @override
  String toString() => '${runtimeType.toString()}: $message';
}

class DatabaseProvider {
  final _firebase = FirebaseDatabase.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> downloadURL(Event event) async {
    final downloadURL = await FirebaseStorage.instance
        .ref('uploads/${event.id}')
        .getDownloadURL();
    event.imagePath = downloadURL;
  }

  Future<void> uploadFile(File file, Event event) async {
    try {
      await FirebaseStorage.instance.ref('uploads/${event.id}').putFile(file);
      print(event.id);
    } on FirebaseException catch (e) {
      throw FirebaseFailure(e.toString());
    }
  }

  void addNote(Note note) async {
    final ref = _firebase.ref('Notes').push();
    note.id = ref.key!;
    await _firebase.ref('Notes/${note.id}').set(note.insertToMap());
  }

  void deleteNote(Note note) async {
    final ref = _firebase.ref('Notes/${note.id}');
    await ref.remove();
  }

  void updateNote(Note note) async {
    final ref = _firebase.ref('Notes');
    await ref.update({
      '${note.id}/circle_avatar_index': note.indexOfCircleAvatar,
      '${note.id}/name': note.eventName,
    });
  }

  Future<List<Note>> dbNotesList() async {
    final snap = await _firebase.ref('Notes').once();
    final noteList = <Note>[];
    var circleAvatarIndex = -1;
    var name = '';
    var subTittleName = '';
    final childKeyList = <dynamic>[];
    DatabaseEvent snapNote;
    for (var childSnapshot in snap.snapshot.children) {
      final childKey = childSnapshot.key;
      childKeyList.add(childKey);
    }
    for (var i = 0; i < childKeyList.length; i++) {
      snapNote = await _firebase.ref('Notes/${childKeyList[i]}').once();
      for (var childSnapshot in snapNote.snapshot.children) {
        if (childSnapshot.key != 'Events') {
          final childNoteKey = childSnapshot.key;
          switch (childNoteKey) {
            case 'name':
              name = (childSnapshot.value as String?)!;
              break;
            case 'circle_avatar_index':
              circleAvatarIndex = (childSnapshot.value as int?)!;
              break;
            case 'sub_tittle_name':
              subTittleName = (childSnapshot.value as String?)!;
              break;
          }
        }
      }
      noteList.add(
        Note(
          id: childKeyList[i],
          eventName: name,
          indexOfCircleAvatar: circleAvatarIndex,
          subTittleEvent: subTittleName,
        ),
      );
    }
    return noteList;
  }

  void addEvent(Event event) async {
    await _firebase
        .ref('Notes/${event.idNote}/Events/${event.id}')
        .set(event.insertToMap());
  }

  void deleteEvent(Event event) async {
    final ref = _firebase.ref('Notes/${event.idNote}/Events/${event.id}');
    await ref.remove();
    await FirebaseStorage.instance.ref('uploads/${event.id}').delete();
  }

  void updateEvent(Event event) async {
    final ref = _firebase.ref('Notes/${event.idNote}/Events');
    await ref.update({
      '${event.id}/event_circle_avatar': event.indexOfCircleAvatar,
      '${event.id}/text': event.text,
      '${event.id}/bookmark_index': event.bookmarkIndex,
    });
  }

  Future<List<Event>> dbEventList(String id) async {
    final eventList = <Event>[];
    final snap = await _firebase.ref('Notes/$id/Events').once();
    final childKeyList = <dynamic>[];
    var text = '';
    var time = '';
    var date = '';
    var imagePath = '';
    var indexOfCircleAvatar = -1;
    var bookmarkIndex = -1;
    DatabaseEvent snapEvent;
    for (var childSnapshot in snap.snapshot.children) {
      final childKey = childSnapshot.key;
      childKeyList.add(childKey);
    }
    for (var i = 0; i < childKeyList.length; i++) {
      snapEvent =
          await _firebase.ref('Notes/$id/Events/${childKeyList[i]}').once();
      for (var childSnapshot in snapEvent.snapshot.children) {
        final childEventKey = childSnapshot.key;
        switch (childEventKey) {
          case 'text':
            text = (childSnapshot.value as String?)!;
            break;
          case 'time':
            time = (childSnapshot.value as String?)!;
            break;
          case 'date_format':
            date = (childSnapshot.value as String?)!;
            break;
          case 'event_circle_avatar':
            indexOfCircleAvatar = (childSnapshot.value as int?)!;
            break;
          case 'bookmark_index':
            bookmarkIndex = (childSnapshot.value as int?)!;
            break;
          case 'image_path':
            imagePath = (childSnapshot.value as String?)!;
            break;
        }
      }
      eventList.add(
        Event(
          idNote: id,
          id: childKeyList[i],
          imagePath: imagePath,
          text: text,
          time: time,
          date: date,
          indexOfCircleAvatar: indexOfCircleAvatar,
          bookmarkIndex: bookmarkIndex,
        ),
      );
    }
    return eventList;
  }
}
