
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> setToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString("token",value);
}

Future<String> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("token");
}

Future<void> removeToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

Future<bool> setUserName(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString("username",value);
}

Future<String> getUserName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("username");
}

Future<bool> setUserId(int value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setInt("userid",value);
}

Future<int> getUserId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt("userid");
}