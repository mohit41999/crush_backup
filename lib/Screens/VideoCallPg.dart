import 'dart:async';
import 'dart:convert';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/models/agora_settings.dart';
import 'package:agora_uikit/models/agora_user.dart';
import 'package:crush/Services/checkbalanceServices/checkbalanceServices.dart';
import 'package:crush/Services/newcallServices.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../firebase_notification_handler.dart';

const APP_ID = '2af01518a23a4f35a6098c9b50467e85';
String time = '';

const Token =
    '0066b462cbcdf254436ab726620f1edb93bIABuntCwp0/RdFu7vSGX7rKs7WOlQcs+nD6NrZ8Fhm5kUbIhF1sAAAAAEAD+bihbwWpMYQEAAQDCakxh';

class VideoCallPage extends StatefulWidget {
  final String callStatus;
  final String channelName;
  final String? caller_id;
  final String? user_id;
  final String CallerImage;

  const VideoCallPage(
      {Key? key,
      required this.channelName,
      required this.callStatus,
      required this.caller_id,
      required this.user_id,
      required this.CallerImage})
      : super(key: key);

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late String channelname;
  late AgoraClient client;
  late DateTime date = DateTime.now();
  late Timer _timer;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      onChange: (value) {
        final displayTime = StopWatchTimer.getDisplayTime(value);

        print('displayTime $displayTime');
        time = displayTime;
        print('onChange $value');
      },
      onEnded: () {});

  @override
  void dispose() async {
    _timer.cancel();
    await _stopWatchTimer.dispose();

    print('dispose called');
    super.dispose();

    // client.sessionController.value.engine!.destroy();
    // Need to call dispose function.
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      channelname = widget.channelName;
      print(widget.caller_id.toString() + 'caller');
      print(widget.user_id.toString() + 'user');

      initialize(channelname, context);
    });
  }

  Future initialize(String channelname, BuildContext context) async {
    client = AgoraClient(
      agoraEventHandlers: AgoraEventHandlers(
        joinChannelSuccess: (v, i, j) {
          setState(() {
            _timer = Timer.periodic(Duration(seconds: 3), (timer) {
              setState(() {
                if (Rejcted) {
                  _timer.cancel();
                  client.sessionController.endCall();
                  client.sessionController.dispose();
                  Navigator.pop(context);
                } else {}
              });
            });
          });
        },
        userJoined: (i, j) {
          setState(() {
            (widget.callStatus == 'o')
                ? CheckBalanceServices().checkvideobalance()
                : null;

            _stopWatchTimer.onExecute.add(StopWatchExecute.start);
            _stopWatchTimer.onChange;
            _timer = Timer.periodic(Duration(seconds: 59), (timer) {
              setState(() {
                print(
                    'hello after 5 secsssssssssssssssssssssssssssssssssss video');
                (widget.callStatus == 'o')
                    ? CheckBalanceServices().checkvideobalance().then((value) {
                        print(value['data']['status'].toString());
                        if (value['data']['status'].toString() == 'n') {
                          timer.cancel();
                          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                          client.sessionController.endCall();
                          client.sessionController.dispose();
                          Navigator.pop(context);
                        } else {}
                      })
                    : null;
              });
            });

            print(
                'iiiiiiiiiiiiiiiiiiiiiooooooooooooooooooooooooooooooooooooooooooooo');
          });
        },
        leaveChannel: (v) {
          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
          _timer.cancel();
        },
        userOffline: (i, j) {
          setState(() {
            _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
            _timer.cancel();
            print(StopWatchExecute.stop.toString());
            print(_stopWatchTimer.secondTime.toString() +
                'ccccccccccccaaaaaalllllllll');

            (widget.callStatus == 'o')
                ? OutgoingUserOffline()
                : IncomingUserOffline();
          });
        },
      ),
      agoraConnectionData: AgoraConnectionData(
        appId: APP_ID,
        channelName: channelname,
      ),
      enabledPermission: [
        //RtcEngine.instance.muteLocalVideoStream(true)
        Permission.microphone,
        Permission.camera,
      ],
    );
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                disabledVideoWidget: Center(
                    child: CircleAvatar(
                  radius: 150,
                  backgroundImage: NetworkImage(widget.CallerImage),
                )),
                layoutType: Layout.floating,
                client: client,
                showAVState: true,
              ),
              Align(
                alignment: Alignment.topRight,
                child: StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: 0,
                  builder: (context, snap) {
                    final value = snap.data;
                    final displayTime = StopWatchTimer.getDisplayTime(value!);
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime.substring(0, 8),
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              AgoraVideoButtons(
                client: client,
                disconnectButtonChild: MaterialButton(
                  onPressed: () {
                    setState(() {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                      client.sessionController.endCall();
                      client.sessionController.dispose();

                      Navigator.pop(context);
                    });
                  },
                  child: Icon(Icons.call_end, color: Colors.white, size: 35),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  color: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IncomingUserOffline() {
    NewCallServices().add_call(
        user_id: widget.user_id,
        call_duration: time,
        call_status: 'i',
        call_type: 'video',
        caller_id: widget.caller_id);
    NewCallServices().add_call(
        user_id: widget.caller_id,
        call_duration: time,
        call_status: 'o',
        call_type: 'video',
        caller_id: widget.user_id);
  }

  OutgoingUserOffline() {
    NewCallServices().add_call(
        user_id: widget.user_id,
        call_duration: time,
        call_status: 'o',
        call_type: 'video',
        caller_id: widget.caller_id);
    NewCallServices().add_call(
        user_id: widget.caller_id,
        call_duration: time,
        call_status: 'i',
        call_type: 'video',
        caller_id: widget.user_id);
  }
}
