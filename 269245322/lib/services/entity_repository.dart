abstract class EntityRepository<T> {
  Future<List<T>> getEntityList(String? dbPageTitle, String? dbNoteTitle);
  void insert(T entity, String? pageTitle, String? firebasePageTitle);
  void delete(T entity, String? pageTitle, String? firebasePageTitle);
  void update(T entity, String? pageTitle, String? firebasePageTitle);
}
