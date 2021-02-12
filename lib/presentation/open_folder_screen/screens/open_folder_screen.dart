import 'dart:io';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/presentation/full_image_screen/screens/full_image_screen.dart';
import 'package:getx_gallery/presentation/open_folder_screen/controllers/open_folder_controller.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';

class OpenFolderScreen extends StatelessWidget{

  final OpenFolderScreenController c = Get.find();
  static String route = '/open_folder';
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    c.convertStringsToFiles(Get.arguments as List<String>);
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.sort),
              itemBuilder: (_)=>[
                const PopupMenuItem(
                  value: SortTypes.name,
                  child: Text('Name'),
                ),
                const PopupMenuItem(
                  value: SortTypes.date,
                  child: Text('Date'),
                ),
                const PopupMenuItem(
                  value: SortTypes.random,
                  child: Text('RND'),
                ),
              ],
              onSelected: c.sort
          )
        ],
      ),
      body: _buildGrid()
    );
  }

  Widget _buildGrid(){
    return Obx(()=>
        DraggableScrollbar.arrows(
          labelTextBuilder: (double offset) => Text('${offset ~/ 100}'),
          controller: _controller,
          child:
          GridView.builder(
            controller: _controller,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2
            ),
            itemBuilder: _buildItem,
            itemCount: c.images.length,
          ),
        )
    );
  }

  Widget _buildItem(BuildContext context, int index){
    return GestureDetector(
      onTap: () => Get.to(FullImageScreen(images: c.images, initialPage: index)),
      child: Container(
        margin: const EdgeInsets.all(1),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(c.images[index])
            )
        ),
      ),
    );
  }
}