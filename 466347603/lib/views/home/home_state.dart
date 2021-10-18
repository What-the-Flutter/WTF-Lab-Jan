part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<PageInfo> pages;
  final int selectedContent;
  final String lastMessageEvent;
  final int lastMessagePageId;

  const HomeState({
    this.pages = const [],
    this.selectedContent = 0,
    this.lastMessageEvent = '',
    this.lastMessagePageId = -1,
  });

  HomeState copyWith({
    List<PageInfo>? pages,
    int? selectedContent,
    int? lastMessagePageId,
    String? lastMessageEvent,
  }) {
    return HomeState(
      pages: pages ?? this.pages,
      selectedContent: selectedContent ?? this.selectedContent,
      lastMessagePageId: lastMessagePageId ?? this.lastMessagePageId,
      lastMessageEvent: lastMessageEvent ?? this.lastMessageEvent,
    );
  }

  @override
  List<Object> get props {
    return [pages, selectedContent, lastMessageEvent, lastMessagePageId];
  }
}
