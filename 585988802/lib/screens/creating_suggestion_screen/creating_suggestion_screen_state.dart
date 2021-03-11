class CreatingSuggestionScreenState {
  final bool isWriting;
  final String currentImagePath;

  const CreatingSuggestionScreenState(
    this.isWriting,
    this.currentImagePath,
  );

  CreatingSuggestionScreenState copyWith({
    final bool isWriting,
    final String currentImagePath,
  }) {
    return CreatingSuggestionScreenState(
      isWriting ?? this.isWriting,
      currentImagePath ?? this.currentImagePath,
    );
  }
}
