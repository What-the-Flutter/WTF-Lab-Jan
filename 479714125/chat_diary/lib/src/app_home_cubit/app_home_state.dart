part of 'app_home_cubit.dart';

class AppHomeState extends Equatable {
  final int currentIndex;
  final String title;

  const AppHomeState({
    this.currentIndex = 0,
    this.title = 'Home',
  });

  AppHomeState copyWith(int index) {
    String title;
    switch (index) {
      case 0:
        title = 'Home';
        break;
      case 1:
        title = 'Daily';
        break;
      case 2:
        title = 'Timeline';
        break;
      case 3:
        title = 'Explore';
        break;
      default:
        throw 'Not assigned index';
    }
    return AppHomeState(currentIndex: index, title: title);
  }

  @override
  List<Object?> get props => [currentIndex, title];
}
