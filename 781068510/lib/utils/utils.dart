
String getMonthName () {
  final date = DateTime.now();
  switch (date.month) {
    case 1: return 'January';
    case 2: return 'February';
    case 3: return 'March';
    case 4: return 'April';
    case 5: return 'May';
    case 6: return 'June';
    case 7: return 'July';
    case 8: return 'August';
    case 9: return 'September';
    case 10: return 'October';
    case 11: return 'November';
    case 12: return 'December';
    default: return 'error';
  }
}

String getMonthNameByDate (DateTime date) {
  switch (date.month) {
    case 1: return 'January';
    case 2: return 'February';
    case 3: return 'March';
    case 4: return 'April';
    case 5: return 'May';
    case 6: return 'June';
    case 7: return 'July';
    case 8: return 'August';
    case 9: return 'September';
    case 10: return 'October';
    case 11: return 'November';
    case 12: return 'December';
    default: return 'error';
  }
}

String getFullDate (DateTime date) {
  return '${getMonthNameByDate(date)} ${date.day},'
      ' ${date.year} at ${date.hour}:${date.minute}';
}

String getShortDate (DateTime date) {
  return '${getMonthNameByDate(date)} ${date.day},'
      ' ${date.year}';
}