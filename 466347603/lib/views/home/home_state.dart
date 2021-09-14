part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<PageInfo> pages;
  final int selectedContent;

  const HomeState({
    this.pages = const [],
    this.selectedContent = 0,
  });

  HomeState copyWith({
    List<PageInfo>? pages,
    int? selectedContent,
  }) {
    return HomeState(
      pages: pages ?? this.pages,
      selectedContent: selectedContent ?? this.selectedContent,
    );
  }

  @override
  List<Object> get props {
    return [pages, selectedContent];
  }
}
