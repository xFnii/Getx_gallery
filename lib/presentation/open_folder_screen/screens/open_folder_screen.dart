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
    _controller.addListener(_scrollListener);
    return Hero(
      tag: _c.folder.value.path,
      child: Scaffold(
        appBar: AppBar(
          title: Text(C.fullPathToFile(_c.folder.value.path)),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: Get.back),
          actions: [
            Obx(()=> TextButton.icon(
                onPressed: _c.nextGridSize,
                icon: const Icon(Icons.grid_view, color: Colors.white),
                label: Text(_c.gridSize.value.toString(), style: const TextStyle(color: Colors.white)),
            )),
            PopupMenuButton(
                icon: const Icon(Icons.sort),
                itemBuilder: (_)=>[
                  PopupMenuItem(
                    value: SortTypes.name,
                    child: Row(children: const [
                      Icon(Icons.sort_by_alpha),
                      SizedBox(width: 8),
                      Text('NAME'),
                    ]),
                  ),
                  PopupMenuItem(
                    value: SortTypes.date,
                    child: Row(children: const [
                      Icon(Icons.date_range),
                      SizedBox(width: 8),
                      Text('DATE'),
                    ]),
                  ),
                  PopupMenuItem(
                    value: SortTypes.size,
                    child: Row(children: const [
                      Icon(Icons.photo_size_select_large),
                      SizedBox(width: 8),
                      Text('SIZE'),
                    ]),
                  ),
                  PopupMenuItem(
                    value: SortTypes.random,
                    child: Row(
                        children: const [
                      Icon(Icons.shuffle),
                      SizedBox(width: 8),
                      Text('RND'),
                    ]),
                  ),
                ],
                onSelected: _c.sort
            )
          ],
        ),
        body: Obx(()=> _buildGrid())
      ),
    );
  }

  Widget _buildGrid(){
    return
        DraggableScrollbar.arrows(
          labelConstraints: BoxConstraints(
            maxWidth: Get.width-60,
            maxHeight: 40,
          ),
          controller: _controller,
          child:
          GridView.builder(
            controller: _controller,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _c.gridSize.value
            ),
            itemBuilder: _buildItem,
            itemCount: _c.folder.value.images.length,
          ),
        );
  }

  Widget _buildItem(BuildContext context, int index){
    final thumbnail = _c.folder.value.images[index].thumbnail;
    return GestureDetector(
      onTap: () => Get.toNamed(FullImageScreen.route, arguments: {'images': _c.folder.value.images, 'initialPage': index}),
      child:  (thumbnail.isNotEmpty)?
      Hero(
        tag: _c.folder.value.images[index].path,
        child: Container(
          margin: const EdgeInsets.all(1),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (_c.gridSize>2) ? MemoryImage(thumbnail):  FileImage(File(_c.folder.value.images[index].path)) as ImageProvider
              )
          ),
        ),
      ): const Center(child: Text('X')),
    );
  }

  void _scrollListener(){
    /// Коррекция изменения offset скролла.
    /// При начальном положении скролла равно 0, при максимальном количеству элементов, которые поместятся на одном экране
    /// view*len*offset
    /// ───────────────
    ///     max^2
    final correction = _controller.position.viewportDimension * _c.folder.value.images.length * _controller.offset/(_controller.position.maxScrollExtent * _controller.position.maxScrollExtent);

    /// Вычисление номер последнего элемента на экране.
    /// len*(offset+view)
    /// ───────────────     – [correction]
    ///     max
    final lastElement = _c.folder.value.images.length*(_controller.offset+_controller.position.viewportDimension)/ _controller.position.maxScrollExtent - correction;
     _c.generateThumbnails(lastElement.toInt());

  }
}