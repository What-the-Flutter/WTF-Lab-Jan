part of 'main_screen_cubit.dart';

class MainscreenState {
  final int selectedTab;

  MainscreenState({this.selectedTab = 0});

  MainscreenState copyWith({int? selectedTab}) {
    return MainscreenState(selectedTab: selectedTab ?? this.selectedTab);
  }
}
