import 'package:RasPiFinder/models/rasps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MSharedPreferences {
  MSharedPreferences._privateConstructor();

  static final MSharedPreferences instance =
      MSharedPreferences._privateConstructor();

  addIntToSF(String s, List<Rasp> myPies) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setInt('intValue', 123);
  }

  Future<int> getIntValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getInt(key) ?? null;
  }

  setBooleanValue(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  Future<bool> getBooleanValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(key) ?? false;
  }
}
