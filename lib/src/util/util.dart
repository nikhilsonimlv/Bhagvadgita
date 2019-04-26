import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

class Util {
  static Future<bool> setTokenIntoSharedPreferences(String token) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var currentTime = new DateTime.now();
    var tokenValidityTime = currentTime.add(new Duration(minutes: 1));
    print("Token validity time is " + tokenValidityTime.hour.toString()+":"+tokenValidityTime.minute.toString()+":"+tokenValidityTime.second.toString());
    sharedPreferences.setString(
        "token_time", tokenValidityTime.toIso8601String());
    return sharedPreferences.setString("access_token", token);
  }

  static Future<String> getTokenFromSharedPreferences() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.get("access_token");
  }

  static Future<bool> checkToken() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
   try{
      var currentTime = new DateTime.now();
      var tokenValidityTime = DateTime.parse(sharedPreferences.get("token_time"));
      print("Current Time = " +currentTime.hour.toString()+":"+currentTime.minute.toString()+":"+currentTime.second.toString());
      print("Token last saved at = " +tokenValidityTime.hour.toString()+":"+tokenValidityTime.minute.toString()+":"+tokenValidityTime.second.toString());
      print("Token Validity = "+currentTime.isBefore(tokenValidityTime).toString());
      return currentTime.isBefore(tokenValidityTime);
    }catch(_){
      return false;
    }

  }
}
