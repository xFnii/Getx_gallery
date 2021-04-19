import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_gallery/data/databases/hive_db/database.dart';
import 'package:getx_gallery/data/repository/impl/local_datasource_hive.dart';
import 'package:getx_gallery/data/repository/impl/repository_impl.dart';
import 'package:getx_gallery/data/repository/local_datasource.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/presentation/common/controller/folder_controller.dart';
import 'package:hive/hive.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:isolate_handler/isolate_handler.dart';

Future init() async {
  await _init();
  await _put();
}

Future _put() async {
  Get.put<Stopwatch>(Stopwatch()..start());
  Get.lazyPut<IsolateHandler>(() => IsolateHandler());
  Get.put<HiveDB>(HiveDB());
  await Get.find<HiveDB>().init();

  Get.lazyPut<LocalDataSource>(() => LocalDataSourceHive(Get.find<HiveDB>()));
  Get.lazyPut<Repository>(() => RepositoryImpl(localDataSource: Get.find<LocalDataSource>()));
  Get.lazyPut<FolderController>(() => FolderController(repository:  Get.find<Repository>()));
}

Future _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
}