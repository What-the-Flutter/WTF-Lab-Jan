class Message {
  String _message;

  bool _isSelected = false;
  bool _isEdited = false;
  bool _isFavorite = false;

  Message(this._message);

  String get message {
    return _message;
  }

  bool sendNewMessage(String message) {
    _message = message;
    return true;
  }

  bool favoriteMessage(bool favorite) {
    _isFavorite = favorite;
    return true;
  }

  bool inverseChosen() {
    _isFavorite = !_isFavorite;
    return true;
  }

  bool inverseSelected() {
    _isSelected = !_isSelected;
    return true;
  }

  bool selectMessage(bool select) {
    _isSelected = select;
    return true;
  }

  bool editMessage(bool edit) {
    _isEdited = edit;
    return true;
  }

  bool get isMessageFavorite {
    return _isFavorite;
  }

  bool get isMessageEdit {
    return _isEdited;
  }

  bool get isMessageSelected {
    return _isSelected;
  }
}
