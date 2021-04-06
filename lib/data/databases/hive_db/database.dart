import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_gallery/data/databases/hive_db/models/folder.dart';
import 'package:getx_gallery/data/databases/models/db_models.dart' as db_model;
import 'package:getx_gallery/data/isolates/sorting_isolate_vanila.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';
import 'package:hive/hive.dart';


class HiveDB {
  final _folderTag = 'folders';
  late Box<Folder> _folderBox;
  final StreamController<Folder> _streamController = StreamController<Folder>();
  final stopWatch = Get.find<Stopwatch>();

  Stream<Folder> watchFolder() => _streamController.stream;

  Future<void> init() async {
    _registerAdapters();
    await _openBoxes();
  }

  void _registerAdapters(){
    Hive.registerAdapter(FolderAdapter());
    Hive.registerAdapter(SortTypesAdapter());
  }

  Future _openBoxes() async {
    _folderBox = await Hive.openBox<Folder>(_folderTag);
  }

  void addFolders(List<db_model.Folder> folders)  {
    final foldersBox = _folderBox;
    for(final folder in folders){
      foldersBox.put(folder.name, folder.toHive());
    }
    foldersBox.close();
  }

  void updateFolder(db_model.Folder folder) {
    final hiveFolder = folder.toHive();
    _folderBox.put(folder.name.hashCode, hiveFolder);
    _streamController.add(hiveFolder);
  }

  void addFolder(db_model.Folder folder) {
    final oldFolder = _folderBox.get(folder.name.hashCode);
    final newFolder = folder.toHive();
    if(oldFolder==null) {
      _streamController.add(newFolder);
      _folderBox.put(folder.name.hashCode, newFolder);
    } else {
      if(!ListEquality().equals(newFolder.paths, oldFolder.paths)) {
        compute(sortIsolate, {'files': folder.paths.toList(), 'type': folder.sortType.index}).then((value) => _sortHandler(value, folder));
      }
    }
  }

  void actualizeFolder(db_model.Folder folder){
    final hiveFolder = folder.toHive();
    _folderBox.put(folder.name.hashCode, hiveFolder);
    _streamController.add(hiveFolder);
  }

  Future _sortHandler(List<String> paths, db_model.Folder folder) async {
    final newFolder = folder.toHive(sortType: folder.sortType, paths: paths);
    _streamController.add(newFolder);
    _folderBox.put(folder.name.hashCode, newFolder);
  }

  void deleteFolder(int name){
    _folderBox.delete(name);
  }

  List<db_model.Folder> getFolders() {
    final foldersBox = _folderBox;
    final keys = foldersBox.keys;
    return [
      for(final key in keys)
        db_model.Folder.fromHive(foldersBox.get(key) ?? Folder())
    ];
  }

  Future deleteAll() async {
    await _folderBox.clear();
  }
}

