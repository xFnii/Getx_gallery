import 'dart:io';
import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/image.dart';

class FullImageScreenController extends GetxController {
  final _currentIdx = 0.obs;
  final images = <File>[].obs;
  final hided = false.obs;
  late final int initialPage;
  late final Function(int) _correctOffset;

  int get currentIdx => _currentIdx.value;

  set currentIdx(int index) {
    _currentIdx.value = index;
    _correctOffset(index);
  }

  @override
  void onInit() {
    initialPage = _currentIdx.value = Get.arguments['initialPage'] as int;
    _correctOffset = Get.arguments['offsetCallback'];
    images.addAll((Get.arguments['images'] as List<Image>)
        .map((e) => File(e.path))
        .toList());
    super.onInit();
  }

  void toggleHide() {
    hided.value = !hided.value;
  }
}