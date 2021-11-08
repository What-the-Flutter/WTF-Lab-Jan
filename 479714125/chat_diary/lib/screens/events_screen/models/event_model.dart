class EventModel {
  String text;
  bool isSelected;
  final String date;

  EventModel({
    required this.text,
    required this.date,
    this.isSelected = false,
  });
}
