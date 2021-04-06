class TabState {
  final int prevIndex;
  final int currIndex;

  TabState(this.prevIndex, this.currIndex);

  TabState copyWith({
    int prevIndex,
    int currIndex,
  }) =>
      TabState(
        prevIndex ?? this.prevIndex,
        currIndex ?? this.currIndex,
      );

}
