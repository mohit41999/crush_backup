import 'dart:convert';

import 'package:crush/Model/favourite_profile.dart';
import 'package:crush/Model/home_usr_profile.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:http/http.dart' as http;

class HomeUserProfileService {
  Future<HomeUserProfile> gethomeProfile(
      {required String user_id, String? login_userID}) async {
    var Response = await http
        .post(Uri.parse(BASE_URL + AppConstants.HOME_USER_PROFILE), body: {
      'token': '123456789',
      'user_id': user_id,
      'login_userID': login_userID
    });
    return HomeUserProfile.fromJson(jsonDecode(Response.body));
  }
}
