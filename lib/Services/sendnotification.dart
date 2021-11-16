import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

late String name = '';

Future sendnotification(String channelname, String fcm_token, String screenId,
    String? caller_id, String? user_id, String user_Image) async {
  print(
      user_id.toString() + caller_id.toString() + 'ssssssssssssssssssssssssss');
  var Response =
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode({
            "registration_ids": [
              fcm_token,
            ], //token
            "collapse_key": "type_a",
            "notification": {
              "body": "${name}",
              "title": (screenId == '0')
                  ? "Incoming Video Call "
                  : "Incoming Voice Call "
            },
            "data": {
              "title": " ",
              "channel_name": channelname,
              "screenId": screenId,
              "caller_id": caller_id,
              "user_id": user_id,
              "user_Image": user_Image,
            }
          }),
          encoding: Encoding.getByName("utf-8"),
          headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAATda_6oE:APA91bFRmdzL9GsVLyzfFmUzSoYYsYajrZA12MA6MppKtmfrmUkDoutIhJfKx80zIlajk4LY3a55KcKBefO6LfqY86XJFqQ7s-9If0WpvfUA8LpI4406EMvzH9VuJQiK6KGdcf1Ad5jV'
      });
  var response = jsonDecode(Response.body.toString());
}

Future rejectCall(String fcm_token) async {
  var Response =
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode({
            "registration_ids": [
              fcm_token,
            ], //token
            "collapse_key": "type_a",
            "notification": {"body": "${name}", "title": "Rejected Call"},
            "data": {"title": "Rejected  Call"}
          }),
          encoding: Encoding.getByName("utf-8"),
          headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAATda_6oE:APA91bFRmdzL9GsVLyzfFmUzSoYYsYajrZA12MA6MppKtmfrmUkDoutIhJfKx80zIlajk4LY3a55KcKBefO6LfqY86XJFqQ7s-9If0WpvfUA8LpI4406EMvzH9VuJQiK6KGdcf1Ad5jV'
      });
  var response = jsonDecode(Response.body.toString());
}
