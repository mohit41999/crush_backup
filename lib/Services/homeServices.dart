import 'dart:convert';

import 'package:crush/Model/homeModel.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:http/http.dart' as http;

class HomeService {
  Future<Home> getHomeDetails(String? user_id) async {
    var Response = await http.post(Uri.parse(BASE_URL + AppConstants.HOME),
        body: {'token': '123456789', 'user_id': user_id});
    print(jsonDecode(Response.body));
    return Home.fromJson(jsonDecode(Response.body));
  }
}
