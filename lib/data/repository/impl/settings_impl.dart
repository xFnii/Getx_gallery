import 'package:getx_gallery/data/repository/settings.dart';
import 'package:getx_gallery/resources/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsImpl extends Settings{

  SettingsImpl({required SharedPreferences sharedPreferences}) : super(sharedPreferences: sharedPreferences);


  @override
  int nextImageGridSize() {
    final gridSize = getImageGridSize();
    var newGridSize = Constants.minImageGridSize;
    if(gridSize != Constants.maxImageGridSize) {
      newGridSize = gridSize+1;
    }
    sharedPreferences.setInt(Settings.imageGridSizeKey, newGridSize);
    return newGridSize;
  }

  @override
  int getImageGridSize() => sharedPreferences.getInt(Settings.imageGridSizeKey) ?? Constants.basicImageGridSize;

  @override
  void setImageGridSize(int size) {
    sharedPreferences.setInt(Settings.imageGridSizeKey, size);
  }

  @override
  int nextFolderGridSize() {
    final gridSize = getFolderGridSize();
    var newGridSize = Constants.minFolderGridSize;
    if(gridSize != Constants.maxFolderGridSize) {
      newGridSize = gridSize+1;
    }
    sharedPreferences.setInt(Settings.folderGridSizeKey, newGridSize);
    return newGridSize;
  }

  @override
  int getFolderGridSize() => sharedPreferences.getInt(Settings.folderGridSizeKey) ?? Constants.basicFolderGridSize;

  @override
  void setFolderGridSize(int size) {
    sharedPreferences.setInt(Settings.folderGridSizeKey, size);
  }
}