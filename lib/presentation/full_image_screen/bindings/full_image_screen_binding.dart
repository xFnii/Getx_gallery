import 'package:get/get.dart';
import 'package:getx_gallery/presentation/full_image_screen/controller/full_image_screen_controller.dart';

class FullImageScreenBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<FullImageScreenController>(FullImageScreenController());
  }
}