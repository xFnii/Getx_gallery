class Folder {
  final String name;
  final List<String> paths;
  final bool hidden;

  Folder({ this.name, this.paths , this.hidden});

  Folder copyWith({String name, List<String> paths, bool hidden})=>
      Folder(
        name: name ?? this.name,
        paths: paths ?? this.paths,
        hidden: hidden ?? this.hidden,
      );

  void addAll(List<String> list) => paths.addAll(list);
  void add(String list) => paths.add(list);
}