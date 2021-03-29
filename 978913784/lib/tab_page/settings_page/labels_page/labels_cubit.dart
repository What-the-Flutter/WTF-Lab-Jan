import 'package:chat_journal/entity/label.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/database_access.dart';
import '../../../data/preferences_access.dart';
import 'labels_state.dart';

class LabelsCubit extends Cubit<LabelsState> {
  LabelsCubit(LabelsState state) : super(state);

  final db = DatabaseAccess();

  void initialize() async {
    emit(state.copyWith(added: await db.fetchLabels()));
  }

  void addLabel(Label label) async {
    db.insertLabel(label);
    emit(state.copyWith(added: state.added..add(label)));
  }

}