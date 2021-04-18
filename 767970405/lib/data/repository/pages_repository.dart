import '../data_provider.dart';
import '../model/model_page.dart';

class PagesRepository {
  final PagesAPI pagesAPI;

  PagesRepository({
    this.pagesAPI,
  });

  Future<List<ModelPage>> pages() {
    return pagesAPI.pages();
  }

  void addPage(ModelPage page) {
    pagesAPI.insertPage(page);
  }

  void editPage(ModelPage page)  {
    pagesAPI.updatePage(page);
  }

  void removePage(int index) {
    pagesAPI.deletePage(index);
  }

  void removeMessages(int pageId) {
    pagesAPI.deleteMessages(pageId);
  }
}
