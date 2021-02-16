class C {
  static String fullPathToFolder(String path) => path.substring(0, path.lastIndexOf('/'));
  static String fullPathToFile(String path) => path.substring(path.lastIndexOf('/')+1, path.length);
}