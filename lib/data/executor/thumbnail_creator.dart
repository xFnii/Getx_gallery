import 'dart:typed_data';

import 'package:flutter/services.dart';

class ThumbnailCreator {
  static const MethodChannel _channel = const MethodChannel('thumbnail_creator');

  static void create({required String path, required int size, required Function(String) callback}) async {
    callback(await _channel.invokeMethod('create', {'path':path, 'width': size, 'height': size}));
  }
}