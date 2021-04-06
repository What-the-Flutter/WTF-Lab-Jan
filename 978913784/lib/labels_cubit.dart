import 'package:chat_journal/data/database_access.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'entity/label.dart';
import 'labels_state.dart';

class LabelsCubit extends Cubit<List<Label>> {
  LabelsCubit(List<Label> state) : super(state);

  DatabaseAccess db = DatabaseAccess.instance();

  void initialize() async =>
    emit(await db.fetchLabels());

  void add(Label label) async {
    label.id = await db.insertLabel(label);
    final updated = state..add(label);
    emit(updated);
  }

  void delete(Label label) {
    db.deleteLabel(label);
    emit(state..remove(label));
  }

  void edit(Label label, Label updated) {
    print(label.id);
    print(updated.id);
    db.updateLabel(updated);
    final updatedState = List<Label>.from(state);
    updatedState[updatedState.indexOf(label)] = updated;
    emit(updatedState);
  }
}
