import '../../models/page_model.dart';

class HomeState {
  final List<PageModel>? listOfPages;

  const HomeState({
    this.listOfPages,
  });

  HomeState copyWith({
    final List<PageModel>? listOfPages,
  }) {
    return HomeState(
      listOfPages: listOfPages ?? this.listOfPages,
    );
  }
}
