import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:isolate_handler/isolate_handler.dart';

final IsolateHandler isolates = Get.find();

final stopWatch = Get.find<Stopwatch>();

Future actualizerIsolate(List<Folder> folders, Function(List<String>) callback) async {
  final isolateName = 'actualizer_${folders.hashCode}';
  print('START $isolateName');
  isolates.spawn(
      entryPoint,
      name: isolateName,
      onReceive: (data) {
        if(data is bool){
          print('END $isolateName');
          isolates.kill(isolateName);
        } else {
          callback(data as List<String>);
        }
      },
      onInitialized: ()=> isolates.send(folders.map((e) => jsonEncode(e)).toList(), to: isolateName)
  );
}

void entryPoint(Map<String, dynamic> context) {
  final messenger = HandledIsolate.initialize(context);
  messenger.listen((jsonFolder) async {
    final result = <String>[];
    final List<Folder> folders = jsonFolder.map<Folder>((e) => Folder.fromJson(jsonDecode(e))).toList();
    var buffer = 0;
    for(final folder in folders){
      buffer++;
      if(!(await Directory(folder.name).exists())) {
        result.add(jsonEncode(folder.copyWith(paths: [])));
      } else {
        for (final path in folder.paths) {
          if (!(await File(path).exists())) {
            folder.paths.remove(path);
          }
        }
        result.add(jsonEncode(folder));
      }
      if(buffer>10) {
        messenger.send(result);
        result.clear();
        buffer = 0;
      }
    }
    if(result.isNotEmpty){
      messenger.send(result);
      messenger.send(true);
    }
  });
}