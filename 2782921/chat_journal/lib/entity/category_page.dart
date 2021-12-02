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
