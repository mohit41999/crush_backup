import 'dart:convert';

import 'package:crush/Model/myAccountModel.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:http/http.dart' as http;

class myAccountService {
  Future<MyAccount> get_myAccount(String? user_id) async {
    var Response = await http.post(
        Uri.parse(BASE_URL + AppConstants.MY_ACCOUNT),
        body: {'token': '123456789', 'user_id': user_id});
    return MyAccount.fromJson(jsonDecode(Response.body));
  }
}
