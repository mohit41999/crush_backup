import 'dart:convert';

import 'package:crush/Model/coinsModel.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:http/http.dart' as http;

class coinsService {
  Future<Coins> getCoins(String? userid) async {
    var Response = await http.post(Uri.parse(BASE_URL + AppConstants.COINS),
        body: {'token': '123456789', 'user_id': userid});
    var r = jsonDecode(Response.body);
    print(r);
    return Coins.fromJson(jsonDecode(Response.body));
  }
}
