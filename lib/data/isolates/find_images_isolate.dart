import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:getx_gallery/resources/excluded_folders.dart';
import 'package:isolate_handler/isolate_handler.dart';

final IsolateHandler isolates = Get.find();



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

    int size=0;
    print('Start file indexing');
    final stopWatch = Stopwatch()..start();

    final fh = FolderHelper(onFolderChange: messenger.send);
    Directory(rootDir).list(recursive: true, followLinks: false).listen((FileSystemEntity event) {

      bool skip = false;
      for(final excludedFolder in excludedFolders){
        if(event.path.contains(excludedFolder)){
          skip = true;
          break;
        }
      }
      if(!skip){
        ///Рекурсивно идём по папкам и файлам
        ///Определяем папка это или же файл
        final type = FileSystemEntity.typeSync(event.path);

        ///Если папка, то меняем у [FolderHelper] рабочую папку на данную
        if(type == FileSystemEntityType.directory) {
          fh.nextFolder(event.path);
          if(event.path.contains('/.')){
            fh.hide();
          }
        }
        ///Если файл, то он вложен в посленюю доблавленную папку
        else {
          final file = C.fullPathToFile(event.path);
          if (file.toLowerCase()=='.nomedia') {
            fh.hide();
          } else if(file.contains(RegExp(r'\.(gif|jpe?g|tiff?|png|webp|bmp)$'))){
            fh.add(event.path);
            size++;
          }
        }

      }
    },
        onDone: ()
        {
          fh.nextFolder('');
          print('Search end, milliSec: ${stopWatch.elapsed.inMilliseconds}, size: $size');
          messenger.send(true);
        });

  });
}

class FolderHelper{
  String currentFolder = '';
  final paths = <String>[];
  final Function(dynamic) onFolderChange;
  bool hidden = false;
  final _hiddenFolders = <String>[];
  final _folders = <String>[];
  final _folders2 = <String>[];

  FolderHelper({required this.onFolderChange});

  void hide(){
    if(!hidden) {
      _hiddenFolders.add(currentFolder);
      hidden = true;
    }
  }

  void add(String path){
    paths.add(path);
  }

  void nextFolder(String folder){
    if(currentFolder.isEmpty){
      currentFolder = folder;
      return;
    }

    if(_folders.contains(currentFolder)) {
      _folders2.add(currentFolder);
    }
    _folders.add(currentFolder);

    ///Проверяем текущую папку на вложенность в скрытую. Все вложенные в скрытую папки должны быть так же скрыты.
    if(!hidden) {
      for (final e in _hiddenFolders) {
        if (currentFolder.contains(e)) {
          hidden = true;
        }
      }
    }

    ///Если в папке есть есть какие-либо элементы, то передаем её обатно, в ином случае переходим на следющую рабочую папку
    if(paths.isNotEmpty){
      onFolderChange(jsonEncode(_toEntity()));
    }
    currentFolder = folder;
    hidden = false;
    paths.clear();
  }

  Folder _toEntity()=> Folder(
      name: currentFolder,
      paths: paths,
      hidden: hidden
  );
}


