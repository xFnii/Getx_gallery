import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/presentation/full_image_screen/bindings/full_image_screen_binding.dart';
import 'package:getx_gallery/presentation/full_image_screen/screens/full_image_screen.dart';
import 'package:getx_gallery/presentation/main_screen/bindings/main_screen_binding.dart';
import 'package:getx_gallery/presentation/main_screen/screens/main_screen.dart';
import 'package:getx_gallery/presentation/open_folder_screen/bindings/open_folder_screen_binding.dart';
import 'package:getx_gallery/presentation/open_folder_screen/screens/open_folder_screen.dart';
import 'package:hive/hive.dart';
import "package:hive_flutter/hive_flutter.dart";

import 'data/isolates/find_images_isolate.dart';
import 'put.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  put();
  runApp(GetMaterialApp(
    initialRoute: MainScreen.route,
    getPages: [
      GetPage(name: MainScreen.route,page: ()=> MainScreen(), binding: MainScreenBinding()),
      GetPage(name: OpenFolderScreen.route,page: ()=> OpenFolderScreen(), binding: OpenFolderScreenBinding()),
      GetPage(name: FullImageScreen.route,page: ()=> FullImageScreen(), binding: FullImageScreenBinding()),
    ],
    title: 'Folder Gallery',
  ));
}

