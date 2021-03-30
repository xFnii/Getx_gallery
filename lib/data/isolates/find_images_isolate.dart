import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';
import 'package:isolate_handler/isolate_handler.dart';

final IsolateHandler isolates = Get.find();



Future findImageIsolate({required String rootDir, required Function callback}) async {
  isolates.kill('findImages');
  isolates.spawn(
      getFolders,
      name: 'findImages',
      onReceive: (data){
        callback(data);
        isolates.kill('findImages');
      },
      onInitialized: ()=> isolates.send(rootDir, to: 'findImages')
  );
}

void getFolders(Map<String, dynamic> context) {
  final messenger = HandledIsolate.initialize(context);

  messenger.listen((data) {
    final String rootDir = data as String;
    //final result = <Folder>[];

    int size=0;
    print('Start file indexing');
    final stopWatch = Stopwatch()..start();

    final fh = FolderHelper();

    Directory(rootDir).list(recursive: true, followLinks: false).listen((event) {
      final file = C.fullPathToFile(event.path);
      final folder = C.fullPathToFolder(event.path);
      if(folder!=fh.currentFolder){
        if(fh.currentFolder.isNotEmpty){
          //result.add(fh.toEntity());
          fh.nextFolder(folder, messenger.send);
        }
      }
      if (file.toLowerCase()=='.nomedia' || folder.contains('/.')) {
        fh.hide();
      }
      if(file.contains(RegExp(r'\.(gif|jpe?g|tiff?|png|webp|bmp)$'))){
        fh.paths.add(event.path);
        size++;
      }
    },
        onDone: ()
        {
          messenger.send(jsonEncode(fh.toEntity()));
          print('Search end, milliSec: ${stopWatch.elapsed.inMilliseconds}, size: $size');
        });
  });
}

class FolderHelper{
  String currentFolder = '';
  final paths = <String>[];
  bool hidden = false;

  void hide(){
    hidden = true;
  }

  void nextFolder(String folder, Function(dynamic) callback){
    currentFolder = folder;
    hidden = false;
    paths.clear();
    callback(jsonEncode(toEntity()));
  }

  Folder toEntity()=> Folder(
      name: currentFolder,
      paths: paths,
      hidden: hidden,
      sortType: SortTypes.name
  );
}

// void entryPoint(Map<String, dynamic> context) {
//   final messenger = HandledIsolate.initialize(context);
//
//   // Triggered every time data is received from the main isolate.
//   messenger.listen((data) {
//     final List<String> paths = data['paths'];
//     final List<String> folders = data['folders'];
//     final String rootDir = data['rootDir'];
//
//     final Map<String, List<String>> result = {'paths': [], 'folders': []};
//     int size=0;
//     print('Start file indexing');
//     final stopWatch = Stopwatch()..start();
//     var questionableFolder = '';
//     var alreadySynced = false;
//     Directory(rootDir).list(recursive: true, followLinks: false).listen((event) {
//       final file = C.fullPathToFile(event.path);
//       final folder = C.fullPathToFolder(event.path);
//       if ((file.toLowerCase()=='.nomedia' || folder.contains('/.')) && folder!=questionableFolder) {
//         questionableFolder = folder;
//         alreadySynced = false;
//       }
//       if(file.contains(RegExp(r'\.(gif|jpe?g|tiff?|png|webp|bmp)$'))){
//         if(questionableFolder==folder && !alreadySynced){
//           alreadySynced = true;
//           if(!folders.contains(questionableFolder)) {
//             result['folders'].add(questionableFolder);
//           }
//         }
//         size++;
//         if(!paths.contains(event.path)) {
//           result['paths'].add(event.path);
//         }
//       }
//     },
//         onDone: ()
//         {
//           if(result['folders'].isNotEmpty) {
//             var i = 0;
//             while(i<result['folders'].length){
//               result['folders'].removeWhere((element) => element.contains(result['folders'][i]) && element!=result['folders'][i]);
//               i++;
//             }
//           }
//           messenger.send(result);
//           result.clear();
//           print('Search end, milliSec: ${stopWatch.elapsed.inMilliseconds}, size: $size');
//         });
//   });
// }


