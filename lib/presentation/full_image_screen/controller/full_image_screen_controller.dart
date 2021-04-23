import 'dart:io';
import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/image.dart';

class FullImageScreenController extends GetxController{
  final currentIdx = 0.obs;
  final images = <File>[].obs;
  final hided = false.obs;
  late final int initialPage;

  @override
  void onInit() {
    initialPage = currentIdx.value = Get.arguments['initialPage'] as int;
    images.addAll((Get.arguments['images'] as List<Image>).map((e) => File(e.path)).toList());
    super.onInit();
  }

  void toggleHide(){
    hided.value = !hided.value;
  }
}