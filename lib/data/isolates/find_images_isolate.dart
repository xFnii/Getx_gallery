import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/entities.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:getx_gallery/resources/excluded_folders.dart';
import 'package:isolate_handler/isolate_handler.dart';

final IsolateHandler isolates = Get.find();
final hiddenFolders = <String>[];


Future findImageIsolate({required String rootDir, required Function callback}) async {
  print('findImages');
  isolates.spawn(
      getFolders,
      name: 'findImages',
      onReceive: (data) {
        if(data is bool) {
          isolates.kill('findImages');
        } else {
          callback(data);
        }
      },
      onInitialized: ()=> isolates.send(rootDir, to: 'findImages')
  );
}

void getFolders(Map<String, dynamic> context) {
  final messenger = HandledIsolate.initialize(context);

  messenger.listen((data) {
    final String rootDir = data as String;
    print('Start file indexing');
    _getAllFiles(Directory(rootDir), messenger.send);
    print('End file indexing');
  });
}

void _getAllFiles(Directory directory, Function(dynamic) onFolderChange){
  bool skip = false;
  for(final excludedFolder in excludedFolders){
    if(directory.path.contains(excludedFolder)){
      skip = true;
      break;
    }
  }

  if(!skip){
    final fh = FolderHelper(onFolderChange: onFolderChange, currentFolder: directory.path);
    if(directory.path.contains('/.')){
      fh.hide();
    }
    final list = directory.listSync();
    for(final e in list){
      final type = FileSystemEntity.typeSync(e.path);
      if(type == FileSystemEntityType.directory) {
        _getAllFiles(Directory(e.path), onFolderChange);
      } else if(type == FileSystemEntityType.file){
        final file = C.fullPathToFile(e.path);
        if (file.toLowerCase()=='.nomedia') {
          fh.hide();
        } else if(file.contains(RegExp(r'\.(gif|jpe?g|tiff?|png|webp|bmp)$'))){
          fh.add(e.path);
        }
      }
    }
    fh.send();
  }
}


class FolderHelper{
  final String currentFolder;
  final paths = <String>[];
  final Function(dynamic) onFolderChange;
  bool hidden = false;

  FolderHelper({required this.onFolderChange,required this.currentFolder});

  void hide(){
    if(!hidden) {
      hiddenFolders.add(currentFolder);
      hidden = true;
    }
  }

  void add(String path){
    paths.add(path);
  }

  void send(){

    ///Проверяем текущую папку на вложенность в скрытую. Все вложенные в скрытую папки должны быть так же скрыты.
    if(!hidden) {
      for (final e in hiddenFolders) {
        if (currentFolder.contains(e)) {
          hidden = true;
        }
      }
    }

    ///Если в папке есть есть какие-либо элементы, то передаем её обатно, в ином случае переходим на следющую рабочую папку
    if(paths.isNotEmpty){
      onFolderChange(jsonEncode(_toEntity()));
    }
  }

  Folder _toEntity()=> Folder(
      path: currentFolder,
      images: paths.map((e) => Image(path: e, thumbnail: Uint8List(0))).toList(),
      hidden: hidden
  );
}


