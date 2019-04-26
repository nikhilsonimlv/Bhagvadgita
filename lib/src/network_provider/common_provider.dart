import 'dart:async';

import 'package:bhagavadgita/src/resources/model/all_chapters_model.dart';
import 'package:bhagavadgita/src/resources/model/token_model.dart';
import 'package:bhagavadgita/src/util/constant.dart';
import 'package:bhagavadgita/src/util/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CommonProvider {
  String tokenUrl = Constant.tokenUrl;
  String allChapterUrl = Constant.getAllChapters;

  final successCode = Constant.succcessCode;

  Future<String> fetchAuthToken() async {
    print("***** Token is fetching from API *****");

    final response = await http.post(tokenUrl, body: {
      "client_id": "Gn0AYHkjY86DBydl3f33GdAXTZevHPbg6QIf22kn",
      "client_secret": "PomaXUlvLiG32orm8nqrfkI12iNmmgrTXCWXp4y3EuWoDpRYDF",
      "grant_type": "client_credentials",
      "scope": "verse chapter"
    });
    print("Server response is " + response.body.toString());
    print("Status code is " + response.statusCode.toString());

    final responseString = jsonDecode(response.body);
   // print("Access Token after json decode is" + responseString.toString());
    if (response.statusCode == successCode) {
      print("Token is "+TokenModel.fromJson(responseString).accessToken);
      Util.setTokenIntoSharedPreferences(TokenModel.fromJson(responseString).accessToken);
      return Util.getTokenFromSharedPreferences();
    } else {
      throw Exception("Failed To get the token");
    }
  }

  Future<String> fetchTokenFromDB() async {
    print("***** Token is fetching from DB *****");
    final response = await Util.getTokenFromSharedPreferences();
    print("Token is "+ response.toString());

    return response.toString();
  }

  Future<AllChaptersModel> fetchAllChapters() async {
    String token;
    print("Under fetchAllChapters");
    bool checkToken = await Util.checkToken();
    if(checkToken){
      token  = await fetchTokenFromDB();
    }else{
      token  = await fetchAuthToken();
    }
    if(token.length >0){
      final response = await http.get(allChapterUrl + token);
      final jsonResponse = jsonDecode(response.body);
      print("jsonResponse of chapters "+ jsonResponse.toString());

      if (response.statusCode == Constant.succcessCode) {
        return AllChaptersModel.fromJson(jsonResponse);
      }  else {
        throw Exception("Failed To get the chapters");
      }
    }else{
      throw Exception("Failed To get the token");
    }

  }
}
