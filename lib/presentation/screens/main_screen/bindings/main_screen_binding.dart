import 'package:get/get.dart';
import 'package:getx_gallery/presentation/screens/main_screen/controllers/main_screen_controller.dart';

class MainScreenBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<MainScreenController>(MainScreenController());
  }
}