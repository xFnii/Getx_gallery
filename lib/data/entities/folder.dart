class Folder {
  final String name;
  final List<String> paths;
  final bool hidden;

  Folder({ this.name, this.paths, this.hidden});

  void addAll(List<String> list) => paths.addAll(list);
  void add(String list) => paths.add(list);
}