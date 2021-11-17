import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Message {
  final String text;
  final DateTime date;
  final bool favourite;
  final MapEntry<String, IconData>? event;
  final File? image;

  Message(this.text, this.date, this.favourite, [this.event, this.image]);

  String get formattedDate => DateFormat('dd MMMM yyyy').format(date);

  String get formattedTime => DateFormat('Hm').format(date);

}
