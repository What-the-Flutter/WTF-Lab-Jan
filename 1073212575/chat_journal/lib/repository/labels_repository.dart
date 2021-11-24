import '../database.dart';
import '../models/events_model.dart';

class LabelsRepository {
  final DBProvider db;

  LabelsRepository(this.db);

  Future<List<Label>> labelsList() async {
    return await db.labelsList();
  }

  void insertLabel(Label label) async {
    db.insertLabel(label);
  }

  void deleteLabel(String labelId) async {
    db.deleteLabel(labelId);
  }
}
