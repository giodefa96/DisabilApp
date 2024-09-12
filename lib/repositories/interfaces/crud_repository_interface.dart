abstract class CrudOperations<T> {
  Future<T> create(Map<String, dynamic> data);
  Future<T> read(dynamic id);
  Future<T> update(T item);
  Future<void> delete(dynamic id);
  Future<int> deleteAll();
  Future<List<T>> readAll();
}
