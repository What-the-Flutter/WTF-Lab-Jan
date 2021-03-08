abstract class CreatingSuggestionScreenEvent {
  const CreatingSuggestionScreenEvent();
}

class CreatingSuggestionScreenInit extends CreatingSuggestionScreenEvent {
  const CreatingSuggestionScreenInit();
}

class CurrentImageChanged extends CreatingSuggestionScreenEvent {
  final String currentImagePath;

  const CurrentImageChanged(this.currentImagePath);
}

class AddButtonChanged extends CreatingSuggestionScreenEvent {
  final bool isWriting;

  const AddButtonChanged(this.isWriting);
}
