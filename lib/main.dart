import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/presentation/full_image_screen/bindings/full_image_screen_binding.dart';
import 'package:getx_gallery/presentation/full_image_screen/screens/full_image_screen.dart';
import 'package:getx_gallery/presentation/main_screen/bindings/main_screen_binding.dart';
import 'package:getx_gallery/presentation/main_screen/screens/main_screen.dart';
import 'package:getx_gallery/presentation/open_folder_screen/bindings/open_folder_screen_binding.dart';
import 'package:getx_gallery/presentation/open_folder_screen/screens/open_folder_screen.dart';
import 'package:getx_gallery/resources/themes.dart';
import 'package:getx_gallery/translation/translation.dart';
import 'init.dart';


Future<void> main() async {
  await init();
  runApp(
      GetMaterialApp(
        locale: const Locale('en', 'US'),
        themeMode: ThemeMode.dark,
        darkTheme: Themes.dark,
        initialRoute: MainScreen.route,
        translationsKeys: translationKeys,
        getPages: [
          GetPage(name: MainScreen.route, page: ()=> MainScreen(), binding: MainScreenBinding()),
          GetPage(name: OpenFolderScreen.route, page: ()=> OpenFolderScreen(), binding: OpenFolderScreenBinding()),
          GetPage(name: FullImageScreen.route, page: ()=> FullImageScreen(), binding: FullImageScreenBinding()),
        ],
        title: 'Folder Gallery',
  ));
}

