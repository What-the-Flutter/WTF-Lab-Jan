part of 'cubit.dart';

class HomeScreenState extends Equatable {
  final List<PageModel> listOfPages;
  final int newPageId;

  HomeScreenState({
    required this.listOfPages,
    required this.newPageId,
  });

  HomeScreenState copyWith({List<PageModel>? listOfPages, int? newPageId}) {
    return HomeScreenState(
      listOfPages: listOfPages ?? this.listOfPages,
      newPageId: newPageId ?? this.newPageId,
    );
  }

  @override
  String toString() => listOfPages.map((e) => e.toString()).toString();

  @override
  List<Object?> get props => [listOfPages, newPageId];
}
