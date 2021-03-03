extension ListGetElement<T> on List<T> {
  T get(T element) => elementAt(indexOf(element));
}
