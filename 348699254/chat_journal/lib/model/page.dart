import 'package:flutter/material.dart';

import 'event.dart';

class Page {
  final int id;
  final String _name;
  final Icon _icon;
  final DateTime _creationDate;
  final List<Event> _eventList;

  Page(this.id, this._name, this._icon, this._creationDate, this._eventList);

  Icon get icon => _icon;

  String get name => _name;

  DateTime get creationDate => _creationDate;

  List<Event> get eventList => _eventList;
}
