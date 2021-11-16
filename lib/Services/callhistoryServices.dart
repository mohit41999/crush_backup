import 'dart:convert';

import 'package:crush/Model/callHistoryModel.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class CallHistoryServices {
  Future<CallHistoryModel> get_call_history({
    String? user_id,
  }) async {
    var response = await http.post(
      Uri.parse(BASE_URL + AppConstants.CALL_HISTORY),
      body: {
        'token': '123456789',
        'user_id': user_id,
      },
    );
    var Response = jsonDecode(response.body);
    print(Response);
    return CallHistoryModel.fromJson(Response);
  }
}
