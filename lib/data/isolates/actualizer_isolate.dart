import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:isolate_handler/isolate_handler.dart';

final IsolateHandler isolates = Get.find();

final stopWatch = Get.find<Stopwatch>();

Future actualizerIsolate(List<Folder> folders, Function(Folder?) callback) async {
  final isolateName = 'actualizer_${folders.hashCode}';
  print('START $isolateName');
  isolates.spawn(
      entryPoint,
      name: isolateName,
      onReceive: (data) {
        if(data is bool){
          print('END $isolateName');
          isolates.kill(isolateName);
          callback(null);
        } else if (data is List<int>){
          final folder = folders[data[0]];
          callback(folder.copyWith(images: [
            for(int i = 1; i < data.length;i++)
              folder.images[data[i]]
          ]));
        }
      },
      onInitialized: ()=> isolates.send({
        for(final folder in folders)
          folder.path:folder.images.map((e) => e.path).toList()
      }
      , to: isolateName)
  );
}

void entryPoint(Map<String, dynamic> context) {
  final messenger = HandledIsolate.initialize(context);
  messenger.listen((foldersMap) async {
    final stopWatch = Stopwatch()..start();
    print('${stopWatch.elapsedMilliseconds} ACTUALIZER START');
    final result = <int>[];
    final folders = foldersMap as Map<String, List<String>>;
    print('${stopWatch.elapsedMilliseconds}DECODE FOLDERS');
    var index = 0;
    for(final key in folders.keys){
      result.add(index);
      index++;
      print('${stopWatch.elapsedMilliseconds}ACTUALIZE ${key}');
      final dir = Directory(key);
      if(await dir.exists()) {
        for (int i = 0; i<folders[key]!.length; i++ ) {
          if (await File(folders[key]![i]).exists()) {
            result.add(i);
          }
        }
      }
      print('${stopWatch.elapsedMilliseconds}ACTUALIZE END ${key}');
      messenger.send(result);
      result.clear();
      print('${stopWatch.elapsedMilliseconds}ACTUALIZE SEND BUFFER ${key}');
    }
    if(result.isNotEmpty){
      messenger.send(result);
      messenger.send(true);
    }
  });
}