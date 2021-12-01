import 'models/activity_page.dart';

class ActivityPageRepository {
  final List<ActivityPage> pageList = [];

  void addActivityPage(ActivityPage activityPage) {
    pageList.add(activityPage);
  }

  void insertActivityPage(int index, ActivityPage activityPage) {
    pageList.insert(index, activityPage);
  }

  void deleteActivityPageByIndex(int pageIndex) {
    pageList.removeAt(pageIndex);
  }

  void deleteActivityPage(ActivityPage activityPage) {
    pageList.remove(activityPage);
  }

  List<ActivityPage> activityPageList() {
    return pageList;
  }
}