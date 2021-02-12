import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:getx_gallery/utils/buffers/buffer.dart';
import 'package:isolate_handler/isolate_handler.dart';

final isolates = IsolateHandler();



void findImageIsolate(List<String> path, String rootDir, Function callback) async {
  isolates.spawn(
      entryPoint,
      name: 'findImages',
      onReceive: callback,
      onInitialized: ()=> isolates.send({'_path':path, 'path': rootDir}, to: 'findImages')
  );
}

void entryPoint(Map<String, dynamic> context) {
  final messenger = HandledIsolate.initialize(context);

  // Triggered every time data is received from the main isolate.
  messenger.listen((data) {
    final List<String> paths = data['_path'];
    final String rooDir = data['path'];
    final List<String> result = [];
    int size=0;
    print('Start file indexing');
    final stopWatch = Stopwatch()..start();
    Directory(rooDir).list(recursive: true, followLinks: false).listen((event) {
      if(event.path.contains(RegExp(r'\.(gif|jpe?g|tiff?|png|webp|bmp)$'))){
        size++;
        if(!paths.contains(event.path)) {
          result.add(event.path);
        }
        if(result.length>2000){
          print('${(size) ~/ 1000}k');
          messenger.send(result);
          result.clear();
        }
      }
    },
        onDone: ()
        {
          messenger.send(result);
          result.clear();
          print('Search end, sec: ${stopWatch.elapsed.inSeconds}, size: $size');
          isolates.kill('findImages');
        });
  });
}


