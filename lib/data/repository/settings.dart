import 'package:shared_preferences/shared_preferences.dart';

abstract class Settings{
  final SharedPreferences sharedPreferences;

  static const imageGridSizeKey = 'IMAGE_GRID_SIZE';
  static const folderGridSizeKey = 'FOLDER_GRID_SIZE';

  Settings({required this.sharedPreferences});

  int nextImageGridSize();

  int getImageGridSize();

  void setImageGridSize(int size);

  int nextFolderGridSize();

  int getFolderGridSize();

  void setFolderGridSize(int size);
}