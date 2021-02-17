import 'dart:io';
import 'package:get/get.dart';

class FullImageScreenController extends GetxController{
  final currentIdx = 0.obs;
  final images = <File>[].obs;
  final initialPage = 0.obs;

  @override
  void onInit() {
    initialPage.value= currentIdx.value =Get.arguments['initialPage'];
    images.addAll(Get.arguments['images']);
    super.onInit();
  }
}