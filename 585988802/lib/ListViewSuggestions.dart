///This class implements the structure of ListViewSuggestion's row.
class ListViewSuggestions {
  String _nameOfSuggestion;
  String _infoOfSuggestion;
  String _imagePathOfSuggestion;

  ListViewSuggestions(String nameOfSuggestion, String infoOfSuggestion,
      String imagePathOfSuggestion) {
    _nameOfSuggestion = nameOfSuggestion;
    _infoOfSuggestion = infoOfSuggestion;
    _imagePathOfSuggestion = imagePathOfSuggestion;
  }

  // ignore: unnecessary_getters_setters
  String get nameOfSuggestion => _nameOfSuggestion;

  // ignore: unnecessary_getters_setters
  set nameOfSuggestion(String nameOfSuggestion) =>
      _nameOfSuggestion = nameOfSuggestion;

  String get infoOfSuggestion => _infoOfSuggestion;

  set infoOfSuggestion(String nameOfSuggestion) =>
      _infoOfSuggestion = infoOfSuggestion;

  String get imagePathOfSuggestion => _imagePathOfSuggestion;

  set imageOfSuggestion(String imagePathOfSuggestion) =>
      _imagePathOfSuggestion = imagePathOfSuggestion;
}
