class JournalPage {

  int _id;
  String title;
  int iconIndex;
  bool isPinned = false;
  DateTime creationTime;
  Event lastEvent;

  JournalPage(this.title, this.iconIndex, {this.creationTime}) {
    creationTime ??= DateTime.now();
  }

  JournalPage.fromDb(
    int id,
    this.title,
    this.iconIndex,
    this.isPinned,
    this.creationTime,
  ) {
    _id = id;
  }

  JournalPage copyWith({String title, int iconIndex}) {
    var copy = JournalPage(title ?? this.title, iconIndex ?? this.iconIndex,
        creationTime: creationTime);
    copy.isPinned = isPinned;
    return copy;
  }

  @override
  String toString() {
    return '$title';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'title': title,
      'iconIndex': iconIndex,
      'isPinned': isPinned ? 1 : 0,
      'creationTime': creationTime.millisecondsSinceEpoch~/1000,
    };
  }

  int get id => _id;

}

class Event {

  int _id;
  int pageId;

  int iconIndex = 0;
  bool isFavourite = false;
  String description;
  DateTime creationTime;

  Event(this.pageId, this.description, this.iconIndex) {
    creationTime = DateTime.now();
  }

  Event.fromDb(
    int id,
    this.pageId,
    this.iconIndex,
    this.isFavourite,
    this.description,
    this.creationTime,
  ) {
    _id = id;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'pageId': pageId,
      'iconIndex': iconIndex,
      'isFavourite': isFavourite ? 1 : 0,
      'description': description,
      'creationTime': creationTime.millisecondsSinceEpoch~/1000,
    };
  }

  int get id => _id;
}
