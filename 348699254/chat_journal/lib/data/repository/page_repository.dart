import '../data_provider/firebase_database_provider.dart';
import '../model/activity_page.dart';

class ActivityPageRepository {
  final FirebaseDatabaseProvider _db;

  ActivityPageRepository(this._db);

  void insertActivityPage(ActivityPage activityPage) {
    _db.insertActivityPage(activityPage);
  }

  void updateActivityPage(ActivityPage activityPage) {
    _db.updateActivityPage(activityPage);
  }

  Future<List<ActivityPage>> fetchActivityPageList() async {
    return await _db.fetchActivityPageList();
  }

  void deleteActivityPage(ActivityPage activityPage) {
    _db.deleteActivityPage(activityPage);
  }
}
