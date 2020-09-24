import 'package:shared_preferences/shared_preferences.dart';

class MySetting {
  String firstTime = 'firstTime';
  String onLogged = 'log';

  Future<bool> setFirstTime(bool fTime) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.setBool(firstTime, fTime);
  }

  Future<bool> getFirstTime() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getBool(firstTime)??false;
  }

  Future<bool> setLogged(bool logged) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.setBool(onLogged, logged);
  }

  Future<bool> getLogged() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getBool(onLogged)??false;
  }
}
