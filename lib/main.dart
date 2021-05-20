import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/resources/themes.dart';
import 'package:getx_gallery/translation/translation.dart';
import 'init.dart';
import 'presentation/screens/full_image_screen/full_image_screen.dart';
import 'presentation/screens/main_screen/main_screen.dart';
import 'presentation/screens/open_folder_screen/open_folder_screen.dart';


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

