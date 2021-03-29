import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/presentation/full_image_screen/controller/full_image_screen_controller.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullImageScreen extends StatelessWidget{
  static String route = '/open_folder/full_image';


  final FullImageScreenController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          PhotoViewGallery.builder(
              itemCount: c.images.length,
              onPageChanged: (page)=>c.currentIdx.value=page,
              pageController: PageController(initialPage: c.initialPage.value),
              builder: (context, int i){
                return PhotoViewGalleryPageOptions(
                    imageProvider: FileImage(c.images[i]),
                    minScale: PhotoViewComputedScale.contained);
              }),
          Positioned(
              bottom: 10,
              left: 10,
              child: Obx(()=> Text('${c.currentIdx.value+1}/${c.images.length}', style: const TextStyle(color: Colors.white, fontSize: 18, decoration: TextDecoration.none),))),
          Positioned(
              top: 10,
              right: 10,
              left: 10,
              child: Obx(()=> Text(C.fullPathToFile(c.images[c.currentIdx.value].path), style: const TextStyle(color: Colors.white, fontSize: 18, decoration: TextDecoration.none),)))
        ],
      ),
    );
  }

}

