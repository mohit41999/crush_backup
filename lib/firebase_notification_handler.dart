import 'dart:convert';
import 'dart:math';

import 'package:crush/Screens/VideoCallPg.dart';
import 'package:crush/Screens/incomingcallScreen.dart';
import 'package:crush/Screens/signinScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

bool Rejcted = false;

class FirebaseNotifications {
  late FirebaseMessaging _firebaseMessaging;

  void setupFirebase(BuildContext context) {
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getInitialMessage().then((value) {
      if (value != null) {
        if (value.data['title'].toString() == "Rejected  Call") {
          print('Rejected has been called');
          Rejcted = true;
        } else {
          String channel_name = value.data['channel_name'];
          print(channel_name + 'inside videocalllllllllllllllllllllll');

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IncomingCallScreen(
                        channel_name: value.data['channel_name'],
                        Screen_id: value.data['screenId'],
                        caller_id: value.data['caller_id'],
                        user_id: value.data['user_id'],
                        user_Image: value.data['user_Image'],
                      )));
        }
      }
    });
    notificationhandler(context);
  }

  void notificationhandler(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) {
      print(event.data['title']);
      if (event.data['title'].toString() == "Rejected  Call") {
        print('Rejected has been called');
        Rejcted = true;
      } else {
        String channel_name = event.data['channel_name'];
        print(channel_name + 'inside videocalllllllllllllllllllllll');
        String screenId = event.data['screenId'];

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IncomingCallScreen(
                      channel_name: event.data['channel_name'],
                      Screen_id: event.data['screenId'],
                      caller_id: event.data['caller_id'],
                      user_id: event.data['user_id'],
                      user_Image: event.data['user_Image'],
                    )));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event.data['title'].toString() == "Rejected  Call") {
        print('Rejected has been called');
        Rejcted = true;
      } else {
        String channel_name = event.data['channel_name'];
        print(channel_name + 'inside videocalllllllllllllllllllllll');
        String screenId = event.data['screenId'];

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IncomingCallScreen(
                      channel_name: event.data['channel_name'],
                      Screen_id: event.data['screenId'],
                      caller_id: event.data['caller_id'],
                      user_id: event.data['user_id'],
                      user_Image: event.data['user_Image'],
                    )));
      }
    });
  }
}
