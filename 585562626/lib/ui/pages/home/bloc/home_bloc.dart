import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(HomeState initialState) : super(initialState);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is TabSelectedEvent) {
      yield HomeState(index: event.index);
    }
  }
}
