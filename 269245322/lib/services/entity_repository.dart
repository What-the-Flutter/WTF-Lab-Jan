abstract class IRepository<T> {
  Future<List<T>> getEntityList(int? pageId);
  void insert(T entity, int? pageId);
  void delete(T entity, int? pageId);
  void update(T entity, int? pageId);
}
