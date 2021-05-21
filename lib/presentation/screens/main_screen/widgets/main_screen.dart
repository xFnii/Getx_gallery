import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/presentation/common/draggable_scrollbar.dart';
import 'package:getx_gallery/presentation/screens/main_screen/controllers/main_screen_controller.dart';
import 'package:getx_gallery/presentation/screens/open_folder_screen/widgets/open_folder_screen.dart';
import 'package:getx_gallery/resources/converter.dart';

class MainScreen extends StatelessWidget{

  final MainScreenController _c = Get.find();

  final ScrollController _scrollController = ScrollController();
  static String route = '/main';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(()=> TextButton.icon(
            onPressed: _c.nextGridSize,
            icon: const Icon(Icons.grid_view, color: Colors.white),
            label: Text(_c.gridSize.value.toString(), style: const TextStyle(color: Colors.white)),
          )),
          IconButton(icon: const Icon(Icons.delete), onPressed: ()=> _c.deleteAll()),
          IconButton(icon: const Icon(Icons.sync), onPressed: ()=> _c.find()),
          IconButton(icon: Obx(()=>_c.showHidden.value? const Icon(Icons.remove_red_eye_outlined):const Icon(Icons.remove_red_eye)), onPressed: (){
            _c.toggleHidden();
           _scrollController.jumpTo(_scrollController.initialScrollOffset);
          }),
        ],
      ),
      body: _buildGrid(),
    );
  }

  Widget _buildGrid(){
    return Obx(()=>
        DraggableScrollbar.arrows(
          labelConstraints: BoxConstraints(
            maxWidth: Get.width-60,
            maxHeight: 40,
          ),
          labelTextBuilder: (double offset) =>
              Text(
                C.fullPathToFile(_c.getScrollText(offset)),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          controller:_scrollController,
          child: GridView.builder(
            controller:_scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _c.gridSize.value
            ),
            itemBuilder: _buildItem,
            itemCount: _c.folders.length,
          ),
        )
    );
  }

  Widget _buildItem(BuildContext context, int index){
    final thumbnailPath = _c.getThumbnail(index);
    return GestureDetector(
      onTap: (){
        Get.toNamed(OpenFolderScreen.route, arguments: _c.folders[index]);
      },
      behavior: HitTestBehavior.translucent,
      child: Center(
        child: Stack(
          children: [
            Hero(
              tag: _c.folders[index].path,
              child: Container(
                margin: index.isOdd? const EdgeInsets.all(1): const EdgeInsets.fromLTRB(0, 1, 1, 1),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: (thumbnailPath.isNotEmpty)? FileImage(File(thumbnailPath)) : FileImage(File(_c.folders[index].images[0].path)) as ImageProvider
                  )
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 1,
              child: Container(
                alignment: Alignment.center,
                height: 130/4,
                color: Colors.black.withOpacity(0.8),
                child: Text(
                  C.fullPathToFile(_c.folders[index].path),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis, maxLines: 2)
                ),
              ),
          ],
        ),
      ),
    );
  }
}