import 'dart:convert';
import 'package:crush/Model/getFavourites_usersModel.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:http/http.dart' as http;

class getFavUsersService {
  Future<GetFavUsers> getFav_users(String? user_id) async {
    var Response = await http.post(
        Uri.parse(BASE_URL + AppConstants.GET_FAVOURITES),
        body: {'token': '123456789', 'user_id': user_id});
    return GetFavUsers.fromJson(jsonDecode(Response.body));
  }
}
