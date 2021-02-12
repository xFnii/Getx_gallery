import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/presentation/main_screen/bindings/main_screen_binding.dart';
import 'package:getx_gallery/presentation/main_screen/screens/main_screen.dart';
import 'package:getx_gallery/presentation/open_folder_screen/bindings/open_folder_screen_binding.dart';
import 'package:getx_gallery/presentation/open_folder_screen/screens/open_folder_screen.dart';

import 'data/isolates/find_images_isolate.dart';
import 'put.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  put();
  runApp(GetMaterialApp(
    initialRoute: MainScreen.route,
    getPages: [
      GetPage(name: MainScreen.route,page: ()=> MainScreen(), binding: MainScreenBinding()),
      GetPage(name: OpenFolderScreen.route,page: ()=> OpenFolderScreen(), binding: OpenFolderScreenBinding())
    ],
    title: 'Folder Gallery',
  ));
}

