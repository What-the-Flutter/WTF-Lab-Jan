class CreatingCategoriesScreenState {
  final bool isWriting;
  final String currentImagePath;

  const CreatingCategoriesScreenState(
    this.isWriting,
    this.currentImagePath,
  );

  CreatingCategoriesScreenState copyWith({
    final bool isWriting,
    final String currentImagePath,
  }) {
    return CreatingCategoriesScreenState(
      isWriting ?? this.isWriting,
      currentImagePath ?? this.currentImagePath,
    );
  }
}
