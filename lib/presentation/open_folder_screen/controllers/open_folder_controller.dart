import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';

class OpenFolderScreenController extends GetxController{
  final folder = Folder.dummy().obs;
  final Repository _repo = Get.find();

  @override
  void onInit() {
    folder.value = Get.arguments;
    super.onInit();
  }

  Future sort(SortTypes type) async {
    final sortedFolder = await folder.value.switchStatus(type);
    folder.value = sortedFolder;
    _repo.updateFolder(sortedFolder);
  }
}