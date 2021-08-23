import 'package:chat_journal/models/page_mode.dart';


abstract class HomeEvent {}

class ThemeChangeEvent extends HomeEvent {
  final bool isLigth;
  ThemeChangeEvent(this.isLigth);
}

class AddPageEvent extends HomeEvent {
  final AppPage page;
  final List<AppPage> pages;
  AddPageEvent(this.page,this.pages);
}

class EditPageEvent extends HomeEvent {
  final int index;
  final AppPage page;
  final List<AppPage> pages;
  EditPageEvent(this.index,this.page,this.pages);
}

class DeletePageEvent extends HomeEvent {
  final int index;
  final List<AppPage> pages;
  DeletePageEvent(this.index,this.pages);
}

class HomeState {
  final bool? isLigth;
  final List<AppPage> pages;
  HomeState({this.isLigth,  required this.pages});

  HomeState copyWith({bool? isLigth, List<AppPage>? pages}) {
    return HomeState(
      isLigth: isLigth ?? this.isLigth,
      pages: pages ?? this.pages,
    );
  }
}
