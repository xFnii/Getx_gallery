import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/presentation/common/draggable_scrollbar.dart';
import 'package:getx_gallery/presentation/full_image_screen/screens/full_image_screen.dart';
import 'package:getx_gallery/presentation/open_folder_screen/controllers/open_folder_controller.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';

class OpenFolderScreen extends StatelessWidget{

  final OpenFolderScreenController _c = Get.find();
  static String route = '/open_folder';
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(C.fullPathToFile(_c.folder.value.path)),
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
                  value: SortTypes.size,
                  child: Text('Size'),
                ),
                const PopupMenuItem(
                  value: SortTypes.random,
                  child: Text('RND'),
                ),
              ],
              onSelected: _c.sort
          )
        ],
      ),
      body: _buildGrid()
    );
  }

  Widget _buildGrid(){
    return Obx(()=>
        DraggableScrollbar.arrows(
          labelConstraints: BoxConstraints(
            maxWidth: Get.width-60,
            maxHeight: 40,
          ),
          controller: _controller,
          child:
          GridView.builder(
            controller: _controller,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3
            ),
            itemBuilder: _buildItem,
            itemCount: _c.folder.value.images.length,
          ),
        )
    );
  }

  Widget _buildItem(BuildContext context, int index){
    final thumbnail = _c.getThumbnail(index);
    return GestureDetector(
      onTap: () => Get.toNamed(FullImageScreen.route, arguments: {'images': _c.folder.value.images, 'initialPage': index}),
      child:  (thumbnail.isNotEmpty)?  Container(
        margin: const EdgeInsets.all(1),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: (thumbnail.isNotEmpty) ? MemoryImage(thumbnail):  FileImage(File(_c.folder.value.images[index].path)) as  ImageProvider
            )
        ),
      ): const Center(child: Text('X')),
    );
  }
}