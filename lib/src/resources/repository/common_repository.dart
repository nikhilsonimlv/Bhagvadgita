import 'dart:async';

import 'package:bhagavadgita/src/network_provider/common_provider.dart';
import 'package:bhagavadgita/src/resources/model/all_chapters_model.dart';

class CommonRepository {


  CommonProvider _commonProvider = CommonProvider();

  Future<String> fetchToken() => _commonProvider.fetchAuthToken();

  Future<String> fetchTokenFromDb() => _commonProvider.fetchTokenFromDB();

  Future<AllChaptersModel> fetchAllChapters() =>_commonProvider.fetchAllChapters();
}
