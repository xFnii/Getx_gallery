import 'package:shared_preferences/shared_preferences.dart';

abstract class Settings{
  final SharedPreferences sharedPreferences;

  static const gridSizeKey = 'GRID_SIZE';

  Settings({required this.sharedPreferences});

  int nextGridSize();

  int getGridSize();
}