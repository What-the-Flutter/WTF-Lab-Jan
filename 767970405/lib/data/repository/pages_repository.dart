import '../data_provider.dart';
import '../model/model_page.dart';

class PagesRepository {
  final PagesAPI pagesAPI;

  PagesRepository({
    this.pagesAPI,
  });

  Future<List<ModelPage>> pages() async {
    return await pagesAPI.pages();
  }

  void addPage(ModelPage page) async {
    pagesAPI.insertPage(page);
  }

  void editPage(ModelPage page) async {
    pagesAPI.updatePage(page);
  }

  void removePage(int index) async {
    pagesAPI.deletePage(index);
  }

  void removeMessages(int pageId) async {
    pagesAPI.deleteMessages(pageId);
  }
}
