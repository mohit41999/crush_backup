import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BlockServices {
  Future blockUser(String blockuser_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(
        Uri.parse('http://crush.notionprojects.tech/api/add_block_call.php'),
        body: {
          'token': '123456789',
          'user_id': prefs.getString('user_id'),
          'block_user_id': blockuser_id
        });
    var Response = jsonDecode(response.body);
    print(Response);
  }

  Future unblockUser(String blockuser_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(
        Uri.parse('http://crush.notionprojects.tech/api/unblock_call_user.php'),
        body: {
          'token': '123456789',
          'user_id': prefs.getString('user_id'),
          'block_user_id': blockuser_id
        });
    var Response = jsonDecode(response.body);
    print(Response);
  }

  Future getBlockList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(
        Uri.parse('http://crush.notionprojects.tech/api/block_users_list.php'),
        body: {
          'token': '123456789',
          'user_id': prefs.getString('user_id'),
        });
    var Response = jsonDecode(response.body);
    return Response;
    print(Response);
  }

  Future checkblockeduser({required String selected_user_id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(
        Uri.parse(
            'http://crush.notionprojects.tech/api/check_blocked_users.php'),
        body: {
          'token': '123456789',
          'user_id': prefs.getString('user_id'),
          'block_user_id': selected_user_id,
        });
    var Response = jsonDecode(response.body);
    return Response;
  }
}
