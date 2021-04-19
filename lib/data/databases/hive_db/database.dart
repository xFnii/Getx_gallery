import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_gallery/data/databases/hive_db/models/folder.dart';
import 'package:getx_gallery/data/databases/hive_db/models/image.dart';
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
    Hive.registerAdapter(ImageAdapter());
    Hive.registerAdapter(SortTypesAdapter());
  }

  Future _openBoxes() async {
    _folderBox = await Hive.openBox<Folder>(_folderTag);
  }

  void addFolders(List<db_model.Folder> folders)  {
    final foldersBox = _folderBox;
    for(final folder in folders){
      foldersBox.put(folder.path, folder.toHive());
    }
    foldersBox.close();
  }

  void addFolder(db_model.Folder folder) {
    final newFolder = folder.toHive();
    _folderBox.put(folder.path.hashCode, newFolder);
    _streamController.add(newFolder);
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

  db_model.Folder getFolder(int name){
    return db_model.Folder.fromHive(_folderBox.get(name) ?? Folder());
  }

  Future deleteAll() async {
    await _folderBox.clear();
  }
}

