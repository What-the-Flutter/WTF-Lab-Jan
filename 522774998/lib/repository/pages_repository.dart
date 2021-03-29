import '../database/database.dart';
import '../properties/property_page.dart';

class PagesRepository {
  final DBHelper dbHelper;

  PagesRepository({
    this.dbHelper,
  });

  Future<List<PropertyPage>> pagesList() async {
    return await dbHelper.dbPagesList();
  }

  void addPage(PropertyPage page) {
    dbHelper.insertPage(page);
  }

  void editPage(PropertyPage page) {
    dbHelper.updatePage(page);
  }

  void removePage(int index) {
    dbHelper.deletePage(index);
  }

  void removeMessages(int pageId) async {
    dbHelper.deleteMessage(pageId);
  }
}

final List<PropertyPage> dialogPages = <PropertyPage>[
  PropertyPage(
    iconIndex: 12,
    title: 'Gratitude',
    creationTime: DateTime.now(),
    lastModifiedTime: DateTime.now(),
    isPin: false,
  ),
  PropertyPage(
    iconIndex: 11,
    title: 'Notes',
    creationTime: DateTime.now(),
    lastModifiedTime: DateTime.now(),
    isPin: false,
  ),
  PropertyPage(
    iconIndex: 10,
    title: 'Journal',
    creationTime: DateTime.now(),
    lastModifiedTime: DateTime.now(),
    isPin: false,
  ),
];
