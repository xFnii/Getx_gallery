
import 'package:get/get.dart';

abstract class Repository {
  Future find();
  MiniStream<List<String>> watchPaths();
  Future<Map<String, List<String>>> getPaths();
  Future addPaths(List<String> paths);
}