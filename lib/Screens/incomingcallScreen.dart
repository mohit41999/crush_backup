import 'package:crush/Model/favourite_profile.dart';
import 'package:crush/Model/home_usr_profile.dart';
import 'package:crush/Screens/VideoCallPg.dart';
import 'package:crush/Screens/VoiceCall.dart';
import 'package:crush/Services/favourite_profileService.dart';
import 'package:crush/Services/home_user_profile.dart';
import 'package:crush/Services/sendnotification.dart';
import "package:flutter/material.dart";

class IncomingCallScreen extends StatefulWidget {
  final String channel_name;
  final String Screen_id;
  final String caller_id;
  final String user_id;
  final String user_Image;
  const IncomingCallScreen(
      {Key? key,
      required this.channel_name,
      required this.Screen_id,
      required this.caller_id,
      required this.user_id,
      required this.user_Image})
      : super(key: key);

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  late Future<HomeUserProfile> user;
  late String fcm_token = '';
  @override
  void initState() {
    // TODO: implement initState
    print(widget.caller_id + 'llllllllllllll');
    print(widget.caller_id);

    user = HomeUserProfileService()
        .gethomeProfile(user_id: widget.caller_id, login_userID: widget.user_id)
        .then((value) {
      setState(() {
        fcm_token = value.data.fcm_token;
        print(fcm_token + 'yyyyyyyyyyyyyyyyyy');
      });
      return value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incoming VideoCall'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () {
                  rejectCall(fcm_token).then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Text('Reject'),
                color: Colors.red,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  (widget.Screen_id == '0')
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoCallPage(
                                  CallerImage: widget.user_Image,
                                  caller_id: widget.caller_id,
                                  callStatus: 'i',
                                  user_id: widget.user_id,
                                  channelName: widget.channel_name)))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VoiceCallPg(
                                    caller_id: widget.caller_id,
                                    callStatus: 'i',
                                    user_id: widget.user_id,
                                    channelName: widget.channel_name,
                                    CallerImage: widget.user_Image,
                                  )));
                },
                color: Colors.green,
                child: Text('Accept'),
              )
            ],
          )
        ],
      ),
    );
  }
}
