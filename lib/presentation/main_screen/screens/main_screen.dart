import 'dart:io';
import 'dart:ui';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/presentation/main_screen/controllers/main_screen_controller.dart';
import 'package:getx_gallery/presentation/open_folder_screen/screens/open_folder_screen.dart';
import 'package:getx_gallery/resources/converter.dart';

class MainScreen extends StatelessWidget{

  final MainScreenController c = Get.find();
  final ScrollController _controller = ScrollController();

  static String route = '/main';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: ()=> c.deleteAll()),
          IconButton(icon: const Icon(Icons.sync), onPressed: ()=> c.find()),
          IconButton(icon: const Icon(Icons.remove_red_eye), onPressed: (){
            c.toggleHidden();
            _controller.jumpTo(_controller.initialScrollOffset);
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
                C.fullPathToFile(c.folders[offset ~/ 100].name),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          controller: _controller,
          child: GridView.builder(
            controller: _controller,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2
            ),
            itemBuilder: _buildItem,
            itemCount: c.folders.length,
          ),
        )
    );
  }

  Widget _buildItem(BuildContext context, int index){
    return GestureDetector(
      onTap: (){
        Get.toNamed(OpenFolderScreen.route, arguments: c.folders[index].paths);
      },
      child: Stack(
        children: [
          Container(
            margin: index.isOdd? const EdgeInsets.all(1): const EdgeInsets.fromLTRB(0, 1, 1, 1),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(c.folders[index].paths[0]))
              )
            ),
          ),
          Positioned(
            bottom: 0,
            left: 1,
            right: 1,
            child: Container(
              alignment: Alignment.center,
              height: 130/4,
              color: Colors.black.withOpacity(0.8),
              child: Text(
                C.fullPathToFile(c.folders[index].name),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis, maxLines: 2,)
              ),
            ),
        ],
      ),
    );
  }
}