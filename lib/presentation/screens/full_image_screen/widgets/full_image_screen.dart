import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/presentation/screens/full_image_screen/controllers/full_image_screen_controller.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullImageScreen extends StatelessWidget{
  static String route = '/open_folder/full_image';


  final FullImageScreenController _c = Get.find();
  final _fadeDuration = const Duration(milliseconds: 360);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: ()=> _c.toggleHide(),
        child: Obx(() => Hero(
          tag: _c.images[_c.currentIdx].path,
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                  itemCount: _c.images.length,
                  onPageChanged: (page){
                    _c.currentIdx = page;
                  },
                  pageController: PageController(initialPage: _c.initialPage),
                  builder: (context, int i){
                    return PhotoViewGalleryPageOptions(
                        filterQuality: FilterQuality.high,
                        imageProvider: FileImage(_c.images[i]),
                        minScale: PhotoViewComputedScale.contained);
                  }),
              Positioned(
                  top: 10,
                  right: 10,
                  left: 10,
                  child: AnimatedOpacity(
                      duration: _fadeDuration,
                      curve: Curves.easeOutExpo,
                      opacity: _c.hided.value? 0:1,
                      child: Text(C.fullPathToFile(_c.images[_c.currentIdx].path), style: const TextStyle(color: Colors.white, fontSize: 18, decoration: TextDecoration.none)))
              ),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: AnimatedOpacity(
                      duration: _fadeDuration,
                      curve: Curves.easeOutExpo,
                      opacity: _c.hided.value? 0:1,
                      child: Text('${_c.currentIdx+1}/${_c.images.length}', style: const TextStyle(color: Colors.white, fontSize: 18, decoration: TextDecoration.none)))
              ),
            ],
          ),
        ),
      )
      )
    );
  }

}

