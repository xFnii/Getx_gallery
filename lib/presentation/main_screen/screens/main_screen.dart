import 'dart:io';
import 'dart:ui';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/presentation/main_screen/controllers/main_screen_controller.dart';
import 'package:getx_gallery/presentation/open_folder_screen/screens/open_folder_screen.dart';

class MainScreen extends StatelessWidget{

  final MainScreenController c = Get.find();
  final ScrollController _controller = ScrollController();

  static String route = '/main';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: ()=> c.find())
        ],
      ),
      body: _buildGrid(),
    );
  }

  Widget _buildGrid(){
    return Obx(()=>
        DraggableScrollbar.arrows(
          labelTextBuilder: (double offset) => Text('${offset ~/ 100}'),
          controller: _controller,
          child: GridView.builder(
            controller: _controller,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2
            ),
            itemBuilder: _buildItem,
            itemCount: c.folders.keys.length,
          ),
        )
    );
  }

  Widget _buildItem(BuildContext context, int index){
    final folder = c.keys[index];
    return GestureDetector(
      onTap: (){
        Get.toNamed(OpenFolderScreen.route, arguments: c.folders[folder]);
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(1),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: FileImage(File(c.folders[folder][0]))
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
                folder.substring(folder.lastIndexOf('/')+1, folder.length),
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