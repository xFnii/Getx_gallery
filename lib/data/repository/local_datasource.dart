abstract class LocalDataSource{

  Future<List<String>> getPaths();
  Future addPath(String path);
  Future addPaths(List<String> paths);
  Stream<String> watchPaths();
}