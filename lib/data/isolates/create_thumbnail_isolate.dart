import 'package:image/image.dart';


decodeIsolate(Map data) {
  final byte = data['file'].readAsBytesSync();
  final image = decodeImage(byte)!;
  final thumbnail = copyResize(image, width: data['width']);
  return encodeJpg(thumbnail, quality: 30);
}