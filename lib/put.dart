import 'package:get/get.dart';
import 'package:getx_gallery/data/db/database.dart';
import 'package:getx_gallery/data/repository/impl/local_datasource_impl.dart';
import 'package:getx_gallery/data/repository/impl/repository_impl.dart';
import 'package:getx_gallery/data/repository/local_datasource.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/utils/profiler.dart';

void put(){
  Get.lazyPut<Database>(() => Database());
  Get.lazyPut<LocalDataSource>(() => LocalDataSourceImpl());
  Get.lazyPut<Repository>(() => RepositoryImpl());
  Get.put<Map<String, Profiler>>({'dir.liten': Profiler()});
}