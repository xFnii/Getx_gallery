import 'dart:io';
import 'package:get/get.dart';

class FullImageScreenController extends GetxController{
  final currentIdx = 0.obs;
  final images = <File>[].obs;
  final initialPage = 0.obs;

  @override
  void onInit() {
    initialPage.value = currentIdx.value = Get.arguments['initialPage'] as int;
    images.addAll((Get.arguments['images'] as List<String>).map((e) => File(e)).toList());
    super.onInit();
  }
}