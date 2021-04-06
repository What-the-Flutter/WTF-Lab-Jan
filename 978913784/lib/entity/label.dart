class Label {
  int id;
  int iconIndex;
  String description;
  DateTime creationTime;

  Label(this.iconIndex, this.description) {
    creationTime = DateTime.now();
  }

  Label.fromDb(
    this.id,
    this.iconIndex,
    this.description,
    this.creationTime,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'iconIndex': iconIndex,
      'description': description,
      'creationTime': creationTime.millisecondsSinceEpoch ~/ 1000,
    };
  }
}
