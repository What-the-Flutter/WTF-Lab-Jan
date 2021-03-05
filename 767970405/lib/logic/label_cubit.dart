import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repository/icons_repository.dart';

part 'label_state.dart';

class LabelCubit extends Cubit<LabelState> {
  final IconsRepository repository;

  LabelCubit({this.repository, bool isVisible})
      : super(LabelState(isVisible: isVisible));

  void selectionLabel(int index) {
    repository.listIcon[index] =
        repository.listIcon[index].copyWith(isVisible: true);
    emit(LabelState(isVisible: true));
  }

  void unselectionLabel() {
    emit(LabelState(isVisible: false));
  }
}
