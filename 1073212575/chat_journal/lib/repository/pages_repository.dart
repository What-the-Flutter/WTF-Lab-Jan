import '../database.dart';
import '../models/events_model.dart';

class PagesRepository {
  final DBProvider db;

  PagesRepository(this.db);

  void insertPage(EventPages page) {
    db.insertPage(page);
  }

  void updatePage(EventPages page) {
    db.updatePage(page);
  }

  void deletePage(String deletePageId) {
    db.deletePage(deletePageId);
  }

  Future<List<EventPages>> eventPagesList() async {
    return await db.eventPagesList();
  }
}
