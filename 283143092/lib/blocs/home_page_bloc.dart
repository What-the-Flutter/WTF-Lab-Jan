import 'package:bloc/bloc.dart';

class HomePageBloc extends Cubit<Screen>  {
  HomePageBloc(Screen initialState) : super(initialState);

  void setState(Screen screen) => emit(screen);

  void setFromIndex(int index) =>  emit(Screen.values[index]);

}

enum Screen{
  home,
  daily,
  timeline,
}