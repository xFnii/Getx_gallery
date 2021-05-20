import 'package:get/get.dart';
import 'package:getx_gallery/presentation/screens/open_folder_screen/controllers/open_folder_controller.dart';

class OpenFolderScreenBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<OpenFolderScreenController>(OpenFolderScreenController());
  }
}