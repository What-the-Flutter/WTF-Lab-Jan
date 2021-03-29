class Label {
  int id;
  int iconIndex;
  String description;

  Label(this.iconIndex, this.description);

  Label.fromDb(
    this.id,
    this.iconIndex,
    this.description,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'iconIndex': iconIndex,
      'description': description,
    };
  }
}
