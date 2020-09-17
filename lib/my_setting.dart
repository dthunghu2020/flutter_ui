import 'package:shared_preferences/shared_preferences.dart';

class MySetting {
  String firstTime = 'firstTime';

  Future<bool> setFirstTime(bool fTime) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.setBool(firstTime, fTime);
  }

  Future<bool> getFirstTime() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getBool(firstTime)??false;
  }
}
