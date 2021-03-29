import 'dart:io';
import 'package:get/get.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';
import 'package:isolate_handler/isolate_handler.dart';

final IsolateHandler isolates = Get.find();

void sortIsolate(List<File> files, SortTypes type, Function callback) async {
  final isolateName = '${type.toString()}_${files.hashCode}';
  isolates.spawn(
      entryPoint,
      name: isolateName,
      onReceive: (data) {
        callback(List<File>.from(data.map((e) => File(e)).toList()));
        isolates.kill(isolateName);
      },
      onInitialized: ()=> isolates.send({'files': files.map((e) => e.path).toList(), 'type': type.index}, to: isolateName)
  );
}

void entryPoint(Map<String, dynamic> context) {
  final messenger = HandledIsolate.initialize(context);
  messenger.listen((data) {
    final List<File> files = List<File>.from(data['files'].map((e) => File(e)));
    final SortTypes type = SortTypes.values[data['type']];
    switch(type) {
      case SortTypes.date:
        files.sort((a,b)=> a.statSync().changed.compareTo(b.statSync().changed));
        break;
      case SortTypes.reverseDate:
        files.sort((b,a)=> a.statSync().changed.compareTo(b.statSync().changed));
        break;
      case SortTypes.name:
        files.sort((a,b)=> C.fullPathToFile(a.path).compareTo(C.fullPathToFile(b.path)));
        break;
      case SortTypes.reverseName:
        files.sort((b,a)=> C.fullPathToFile(a.path).compareTo(C.fullPathToFile(b.path)));
        break;
      case SortTypes.size:
        files.sort((a, b)=> a.statSync().size.compareTo(b.statSync().size));
        break;
      case SortTypes.reverseSize:
        files.sort((b, a)=> a.statSync().size.compareTo(b.statSync().size));
        break;
      case SortTypes.random:
        files.shuffle();
        break;
    }
    messenger.send(files.map((e) => e.path).toList());
  });
}