abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(int id);
  Future<void> save(T item);
  Future<void> update(T item);
}
