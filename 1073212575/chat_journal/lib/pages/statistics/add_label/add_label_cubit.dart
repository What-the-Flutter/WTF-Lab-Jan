import 'package:chat_journal/models/events_model.dart';
import 'package:chat_journal/repository/labels_repository.dart';
import 'package:chat_journal/repository/pages_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_label_state.dart';

class AddLabelPageCubit extends Cubit<AddLabelState> {
  final PagesRepository pagesRepository;
  final LabelsRepository labelsRepository;

  AddLabelPageCubit(this.pagesRepository, this.labelsRepository)
      : super(
          AddLabelState(
            selectedIconIndex: 0,
            labels: [],
            isColorChanged: false,
          ),
        );

  void addLabel(String text, List iconsList) {
    final label = Label(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: text,
      icon: iconsList[state.selectedIconIndex],
    );
    labelsRepository.insertLabel(label);
  }

  Future<void> init() async {
    final labels = await labelsRepository.labelsList();
    emit(
      state.copyWith(
        labels: labels,
      ),
    );
  }

  void setIconIndex(int i) {
    emit(
      state.copyWith(selectedIconIndex: i),
    );
  }

  void returnToHomePage(
    String text,
    List iconsList,
  ) {
    addLabel(text, iconsList);
  }

  void gradientAnimation() async {
    emit(
      state.copyWith(isColorChanged: false),
    );
    await Future.delayed(const Duration(milliseconds: 60));
    emit(
      state.copyWith(isColorChanged: true),
    );
  }
}
