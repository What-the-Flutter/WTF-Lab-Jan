part of 'home_screen_cubit.dart';

class HomeScreenState {
  final List<PageModel> listOfPages;

  HomeScreenState({required this.listOfPages});

  HomeScreenState copyWith({List<PageModel>? listOfPages}) =>
      HomeScreenState(listOfPages: listOfPages ?? this.listOfPages);

  @override
  String toString() => listOfPages.map((e) => e.toString()).toString();
}
