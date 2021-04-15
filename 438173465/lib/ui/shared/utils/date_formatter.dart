import 'package:intl/intl.dart';

String dateFormatter(DateTime date) {
  final now = DateTime.now();
  final dif = DateTime(
    date.year,
    date.month,
    date.day,
  )
      .difference(
        DateTime(now.year, now.month, now.day),
      )
      .inDays;
  switch (dif) {
    case -1:
      return 'Yesterday';
    case 0:
      return 'Today';

    default:
      return '${DateFormat.MMMd().format(date)}';
  }
}
