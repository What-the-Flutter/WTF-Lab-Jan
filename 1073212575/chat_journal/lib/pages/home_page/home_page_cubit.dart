import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:local_auth/local_auth.dart';

import '../../repository/pages_repository.dart';
import 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final PagesRepository pagesRepository;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  HomePageCubit(this.pagesRepository)
      : super(
          HomePageState(
            isColorChanged: false,
            isSelected: false,
            selectedPageIndex: 0,
            eventPages: [],
          ),
        );

  void authentication() async {
    if (await checkingForBioMetrics() == true) {
      authenticateMe();
    }
  }

  Future<bool> checkingForBioMetrics() async {
    final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print(canCheckBiometrics);
    return canCheckBiometrics;
  }

  Future<void> authenticateMe() async {
    try {
      await _localAuthentication.authenticate(
        biometricOnly: true,
        localizedReason: 'Authenticate, please', // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true, // native process
      );
    } catch (e) {
      print(e);
    }
  }

  void showPages() async {
    final pages = await pagesRepository.eventPagesList();
    emit(
      state.copyWith(
        eventPages: pages,
      ),
    );
  }

  void select(int i) {
    emit(
      state.copyWith(
        selectedPageIndex: i,
        isSelected: true,
      ),
    );
  }

  void unselect() {
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  void delete() {
    pagesRepository.deletePage(state.eventPages[state.selectedPageIndex].id);
    emit(
      state.copyWith(
        selectedPageIndex: state.selectedPageIndex,
        isSelected: false,
      ),
    );
    showPages();
  }

  void edit() {
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  void fix() {
    final selectedPage = state.eventPages[state.selectedPageIndex];
    final tempEventPage = selectedPage.copyWith(
      isFixed: !selectedPage.isFixed,
    );
    pagesRepository.updatePage(tempEventPage);

    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  String latestEventDate() {
    return state.eventPages[state.selectedPageIndex].eventMessages.isEmpty
        ? 'no messages'
        : Jiffy(state
                .eventPages[state.selectedPageIndex].eventMessages.last._date)
            .format('d/M/y h:mm a');
  }

  FutureOr onGoBack(dynamic value) {
    showPages();
  }

  void gradientAnimation() async {
    emit(
      state.copyWith(isColorChanged: false),
    );
    await Future.delayed(const Duration(milliseconds: 30));
    emit(
      state.copyWith(isColorChanged: true),
    );
  }
}
