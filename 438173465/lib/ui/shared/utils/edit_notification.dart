import 'package:flutter/cupertino.dart';

class EditNotification extends Notification {
  final int id;
  final DateTime date;

  EditNotification({
    this.id,
    this.date,
  });
}
