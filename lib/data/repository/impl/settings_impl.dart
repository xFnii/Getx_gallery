import 'package:getx_gallery/data/repository/settings.dart';
import 'package:getx_gallery/resources/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsImpl extends Settings{

  SettingsImpl({required SharedPreferences sharedPreferences}) : super(sharedPreferences: sharedPreferences);


  @override
  int nextGridSize() {
    final gridSize = getGridSize();
    var newGridSize = Constants.minGridSize;
    if(gridSize != Constants.maxGridSize) {
      newGridSize = gridSize+1;
    }
    sharedPreferences.setInt(Settings.gridSizeKey, newGridSize);
    return newGridSize;

  }

  @override
  int getGridSize() => sharedPreferences.getInt(Settings.gridSizeKey) ?? Constants.basicGridSize;
}