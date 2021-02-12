import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullImageScreen extends StatelessWidget{
  final List<File> images;
  final int initialPage;

  const FullImageScreen({Key key, this.images, this.initialPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
        itemCount: images.length,
        pageController: PageController(initialPage: initialPage),
        builder: (context, int i){
          return PhotoViewGalleryPageOptions(
              imageProvider: FileImage(images[i]),
              minScale: PhotoViewComputedScale.contained);
        });
  }

}

