import 'dart:io';

import 'package:getx_gallery/resources/converter.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';

sortIsolate(data) async {
  final type = SortTypes.values[data['type'] as int];
  switch(type) {
    case SortTypes.date:
      final files = List<File>.from((data['files'] as Iterable).map((e) => File(e as String))).toList();
      files.sort((a,b)=> a.statSync().changed.compareTo(b.statSync().changed));
      return files.map((e) => e.path).toList();
    case SortTypes.reverseDate:
      final files = List<File>.from((data['files'] as Iterable).map((e) => File(e as String))).toList();
      files.sort((b,a)=> a.statSync().changed.compareTo(b.statSync().changed));
      return files.map((e) => e.path).toList();
    case SortTypes.name:
      final List<String> files = data['files'];
      files.sort((a,b)=> C.fullPathToFile(a).compareTo(C.fullPathToFile(b)));
      return files;
    case SortTypes.reverseName:
      final List<String> files = data['files'];
      files.sort((b,a)=> C.fullPathToFile(a).compareTo(C.fullPathToFile(b)));
      return files;
    case SortTypes.size:
      final files = List<File>.from((data['files'] as Iterable).map((e) => File(e as String))).toList();
      files.sort((a, b)=> a.statSync().size.compareTo(b.statSync().size));
      return files.map((e) => e.path).toList();
    case SortTypes.reverseSize:
      final files = List<File>.from((data['files'] as Iterable).map((e) => File(e as String))).toList();
      files.sort((b, a)=> a.statSync().size.compareTo(b.statSync().size));
      return files.map((e) => e.path).toList();
    case SortTypes.random:
      final List<String> files = data['files'];
      files.shuffle();
      return files;
  }
}