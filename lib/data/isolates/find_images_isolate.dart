import 'dart:io';
import 'package:get/get.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:isolate_handler/isolate_handler.dart';

final IsolateHandler isolates = Get.find();



void findImageIsolate(List<String> paths, List<String> folders, String rootDir, Function callback) async {
  isolates.kill('findImages');
  isolates.spawn(
      entryPoint,
      name: 'findImages',
      onReceive: (data){
        callback(data);
        isolates.kill('findImages');
      },
      onInitialized: ()=> isolates.send({'paths':paths, 'rootDir': rootDir, 'folders': folders}, to: 'findImages')
  );
}

void entryPoint(Map<String, dynamic> context) {
  final messenger = HandledIsolate.initialize(context);

  // Triggered every time data is received from the main isolate.
  messenger.listen((data) {
    final List<String> paths = data['paths'];
    final List<String> folders = data['folders'];
    final String rooDir = data['rootDir'];

    final Map<String, List<String>> result = {'paths': [], 'folders': []};
    int size=0;
    print('Start file indexing');
    final stopWatch = Stopwatch()..start();
    var questionableFolder = '';
    var alreadySynced = false;
    Directory(rooDir).list(recursive: true, followLinks: false).listen((event) {
      final file = C.fullPathToFile(event.path);
      final folder = C.fullPathToFolder(event.path);
      if ((file.toLowerCase()=='.nomedia' || folder.contains('/.')) && folder!=questionableFolder) {
        questionableFolder = folder;
        alreadySynced = false;
      }
      if(file.contains(RegExp(r'\.(gif|jpe?g|tiff?|png|webp|bmp)$'))){
        if(questionableFolder==folder && !alreadySynced){
          alreadySynced = true;
          if(!folders.contains(questionableFolder)) {
            result['folders'].add(questionableFolder);
          }
        }
        size++;
        if(!paths.contains(event.path)) {
          result['paths'].add(event.path);
        }
      }
    },
        onDone: ()
        {
          if(result['folders'].isNotEmpty) {
            var i = 0;
            while(i<result['folders'].length){
              result['folders'].removeWhere((element) => element.contains(result['folders'][i]) && element!=result['folders'][i]);
              i++;
            }
          }
          messenger.send(result);
          result.clear();
          print('Search end, milliSec: ${stopWatch.elapsed.inMilliseconds}, size: $size');
        });
  });
}


