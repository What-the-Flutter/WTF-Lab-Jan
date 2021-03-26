import 'package:flutter/material.dart';

Future<DateTime> showDateTimePickerDialog(
  BuildContext context, {
  DateTime initialDateTime,
}) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initialDateTime ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
  );
  if (date == null) {
    return DateTime.now();
  }
  final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime) ?? TimeOfDay.now(),
      ) ??
      TimeOfDay.fromDateTime(
        initialDateTime ?? DateTime.now(),
      );
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}
