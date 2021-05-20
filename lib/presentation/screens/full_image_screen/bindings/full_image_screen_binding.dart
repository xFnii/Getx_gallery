import 'package:get/get.dart';
import 'package:getx_gallery/presentation/screens/full_image_screen/controllers/full_image_screen_controller.dart';

class FullImageScreenBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<FullImageScreenController>(FullImageScreenController());
  }
}