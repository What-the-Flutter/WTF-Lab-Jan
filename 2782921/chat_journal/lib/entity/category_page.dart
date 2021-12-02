class CategoryPage {
  int? id;
  String title;
  int iconIndex;
  late DateTime creationTime;

  CategoryPage(this.title, this.iconIndex, {required this.creationTime}) {
    creationTime = creationTime;
  }

  CategoryPage.fromDb(
    this.id,
    this.title,
    this.iconIndex,
    this.creationTime,
  );

  CategoryPage copyWith({required String title, required int iconIndex}) {
    final copy = CategoryPage(title, iconIndex, creationTime: creationTime);
    return copy;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'iconIndex': iconIndex,
      'creationTime': creationTime,
    };
  }

  @override
  String toString() {
    return '$title';
  }
}

class Message {
  int? id;
  int? pageId;
  int iconIndex = 0;
  bool isFavourite = false;
  String? mText;
  late DateTime creationTime;
  String imagePath = '';

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
