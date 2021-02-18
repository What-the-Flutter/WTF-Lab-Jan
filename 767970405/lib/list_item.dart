class ListItem<T> {
  T message;
  bool isSelected;
  bool isFeatured;
  bool isImage;

  ListItem(this.message,
      {this.isSelected = false, this.isFeatured = false, this.isImage = false});
}
