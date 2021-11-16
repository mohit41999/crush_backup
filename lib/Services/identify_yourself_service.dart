import 'dart:convert';

import 'package:crush/Model/identifyYourSelfModel.dart';
import 'package:crush/Services/sendnotification.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IdentifyYrSelfServices {
  Future<IdentifyYourself> postIdentifyYourself(
    String gender,
    String birthday,
    String full_name,
    String city,
    String user_id,
  ) async {
    var response = await http
        .post(Uri.parse(BASE_URL + AppConstants.IDENTIFY_YOURSELF), body: {
      'token': '123456789',
      'gender': gender,
      'birthday': birthday,
      'full_name': full_name,
      'city': city,
      'user_id': user_id
    });

    return IdentifyYourself.fromJson(jsonDecode(response.body));
  }
}
