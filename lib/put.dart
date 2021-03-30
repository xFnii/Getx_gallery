import 'package:get/instance_manager.dart';
import 'package:getx_gallery/data/databases/hive_db/database.dart';
import 'package:getx_gallery/data/repository/impl/local_datasource_hive.dart';
import 'package:getx_gallery/data/repository/impl/repository_impl.dart';
import 'package:getx_gallery/data/repository/local_datasource.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:isolate_handler/isolate_handler.dart';

void put(){
  Get.lazyPut<IsolateHandler>(() => IsolateHandler());
  Get.put<HiveDB>(HiveDB());
  Get.lazyPut<LocalDataSource>(() => LocalDataSourceHive(Get.find<HiveDB>()));
  Get.lazyPut<Repository>(() => RepositoryImpl(localDataSource: Get.find<LocalDataSource>()));
}