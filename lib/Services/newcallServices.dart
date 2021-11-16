import 'dart:convert';

import 'package:crush/util/App_constants/appconstants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class NewCallServices {
  Future add_call({
    String? user_id,
    String? caller_id,
    String? call_type,
    String? call_duration,
    String? call_status,
  }) async {
    var response =
        await http.post(Uri.parse(BASE_URL + AppConstants.ADD_CALL), body: {
      'token': '123456789',
      'user_id': user_id,
      'caller_id': caller_id,
      'call_type': call_type,
      'call_duration': call_duration,
      'call_status': call_status,
    });
    var Response = jsonDecode(response.body);
    print(Response);
  }
}
