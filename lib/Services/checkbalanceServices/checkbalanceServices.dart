import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckBalanceServices {
  Future checkvideobalance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await http.post(
        Uri.parse(
          'http://crush.notionprojects.tech/api/video_coins_deduct.php',
        ),
        body: {
          'token': '123456789',
          'user_id': preferences.getString('user_id'),
        });
    var Response = jsonDecode(response.body);

    return Response;
  }

  Future checkaudiobalance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await http.post(
        Uri.parse(
          'http://crush.notionprojects.tech/api/audio_coins_deduct.php',
        ),
        body: {
          'token': '123456789',
          'user_id': preferences.getString('user_id'),
        });
    var Response = jsonDecode(response.body);
    return Response;
  }
}
