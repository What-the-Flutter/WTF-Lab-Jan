class JournalPage {
  int id;
  String title;
  int iconIndex;
  bool isPinned = false;
  DateTime creationTime;
  Event lastEvent;

  JournalPage(this.title, this.iconIndex, {this.creationTime}) {
    creationTime ??= DateTime.now();
  }

  JournalPage.fromDb(
    this.id,
    this.title,
    this.iconIndex,
    this.isPinned,
    this.creationTime,
  );

  JournalPage copyWith({String title, int iconIndex}) {
    final copy = JournalPage(title ?? this.title, iconIndex ?? this.iconIndex,
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
      'id': id,
      'title': title,
      'iconIndex': iconIndex,
      'isPinned': isPinned ? 1 : 0,
      'creationTime': creationTime.millisecondsSinceEpoch ~/ 1000,
    };
  }
}

class Event {
  int id;
  int pageId;
  int labelId = 0;
  bool isFavourite = false;
  String description;
  DateTime creationTime;
  String imagePath = '';

  Event(this.pageId, this.description, this.labelId) {
    creationTime = DateTime.now();
  }

  Event.fromDb(
    this.id,
    this.pageId,
    this.labelId,
    this.isFavourite,
    this.description,
    this.creationTime,
    this.imagePath,
  );

  Event.fromResource(
    this.pageId,
    this.labelId,
    this.imagePath,
  ) {
    creationTime = DateTime.now();
    description = 'Image';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pageId': pageId,
      'labelId': labelId,
      'isFavourite': isFavourite ? 1 : 0,
      'description': description,
      'creationTime': creationTime.millisecondsSinceEpoch ~/ 1000,
      'imagePath': imagePath,
    };
  }
}
