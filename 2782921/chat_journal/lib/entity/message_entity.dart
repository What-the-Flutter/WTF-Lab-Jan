class Message {
  int? id;
  int? pageId;
  int iconIndex = 0;
  bool isFavourite = false;
  String? mText;
  late DateTime creationTime;

  Message(this.pageId, this.mText, this.iconIndex) {
    creationTime = DateTime.now();
  }

  Message.fromDb(
    this.id,
    this.pageId,
    this.iconIndex,
    this.isFavourite,
    this.mText,
    this.creationTime,
  );

  Message.fromResource(
    this.pageId,
    this.iconIndex,
  ) {
    creationTime = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pageId': pageId,
      'iconIndex': iconIndex,
      'isFavourite': isFavourite ? 1 : 0,
      'content': mText,
      'creationTime': creationTime,
    };
  }
}
