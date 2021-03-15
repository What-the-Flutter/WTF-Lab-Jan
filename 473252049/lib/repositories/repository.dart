abstract class Repository<T> {
  Future<void> insert(T obj);

  Future<void> update(T obj);

  Future<T> delete(int id);

  Future<List<T>> getAll();
}
