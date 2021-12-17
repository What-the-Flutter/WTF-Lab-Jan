class Event {
  String text;
  String time;
  String date;
  bool isSelected;
  bool isBookmark;

  Event({
    this.date = '',
    this.isBookmark = false,
    this.text = '',
    this.time = '',
    this.isSelected = false,
  });
}
