import 'package:chat_journal/model/section.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class MessageData {
  String? mText;
  DateTime datetime;
  bool liked;
  bool deleted;
  File? file;
  Section? section;

  MessageData(
      {required this.mText,
      required this.datetime,
      this.liked = false,
      this.deleted = false,
      this.file,
      this.section});
}
