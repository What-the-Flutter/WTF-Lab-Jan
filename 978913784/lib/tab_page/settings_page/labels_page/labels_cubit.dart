import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/database_access.dart';
import '../../../entity/label.dart';
import 'labels_state.dart';

class LabelsCubit extends Cubit<LabelsState> {
  LabelsCubit(LabelsState state) : super(state);

  final db = DatabaseAccess.instance();

  void initialize() async {
    emit(state.copyWith(added: await db.fetchLabels()));
  }

  void addLabel(Label label) async {
    db.insertLabel(label);
    emit(state.copyWith(added: state.added..add(label)));
  }

}