part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<PageInfo> pages;
  final int selectedContent;
  final int pageId;

  const HomeState({
    this.pages = const [],
    this.selectedContent = 0,
    this.pageId = 0,
  });

  HomeState copyWith({
    List<PageInfo>? pages,
    int? selectedContent,
    int? pageId,
  }) {
    return HomeState(
      pages: pages ?? this.pages,
      selectedContent: selectedContent ?? this.selectedContent,
      pageId: pageId ?? this.pageId,
    );
  }

  @override
  List<Object> get props {
    return [pages, selectedContent, pageId];
  }
}
