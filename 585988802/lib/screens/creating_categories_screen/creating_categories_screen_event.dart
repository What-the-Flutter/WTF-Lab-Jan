abstract class CreatingCategoriesScreenEvent {
  const CreatingCategoriesScreenEvent();
}

class CreatingCategoriesScreenInit extends CreatingCategoriesScreenEvent {
  const CreatingCategoriesScreenInit();
}

class CurrentImageChanged extends CreatingCategoriesScreenEvent {
  final String currentImagePath;

  const CurrentImageChanged(this.currentImagePath);
}

class AddButtonChanged extends CreatingCategoriesScreenEvent {
  final bool isWriting;

  const AddButtonChanged(this.isWriting);
}
