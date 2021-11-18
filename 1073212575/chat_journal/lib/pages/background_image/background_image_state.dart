class BackgroundImageState {
  final String imagePath;
  final bool isImageSetted;

  BackgroundImageState({
    required this.imagePath,
    required this.isImageSetted,
  });

  BackgroundImageState copyWith({
    String? imagePath,
    bool? isImageSetted,
  }) {
    return BackgroundImageState(
      imagePath: imagePath ?? this.imagePath,
      isImageSetted: isImageSetted ?? this.isImageSetted,
    );
  }
}
