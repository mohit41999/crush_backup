import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:crush/Services/checkbalanceServices/checkbalanceServices.dart';
import 'package:crush/Services/newcallServices.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../firebase_notification_handler.dart';
import 'VideoCallPg.dart';

const APP_ID = '2af01518a23a4f35a6098c9b50467e85';

class VoiceCallPg extends StatefulWidget {
  final String callStatus;
  final String channelName;
  final String? caller_id;
  final String? user_id;
  final String CallerImage;

  /// non-modifiable channel name of the page

  /// non-modifiable client role of the page
  final ClientRole? role;

  /// Creates a call page with given channel name.
  const VoiceCallPg(
      {Key? key,
      required this.channelName,
      this.role,
      required this.callStatus,
      required this.caller_id,
      required this.user_id,
      required this.CallerImage})
      : super(key: key);

  @override
  _VoiceCallPgState createState() => _VoiceCallPgState();
}

class _VoiceCallPgState extends State<VoiceCallPg> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  late RtcEngine _engine;
  late Timer _timer;
  late Timer _timer2;

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
  void dispose() {
    // clear users

    _users.clear();
    // destroy sdk
    _timer.cancel();
    _timer2.cancel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    await [Permission.camera, Permission.microphone].request();
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(height: 1920, width: 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.setDefaultAudioRoutetoSpeakerphone(false);
    await _engine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);

    await _engine.disableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        _timer2 = Timer.periodic(Duration(seconds: 3), (timer) {
          setState(() {
            if (Rejcted) {
              _timer2.cancel();
              _onCallEnd(context);
              Navigator.pop(context);
            } else {}
          });
        });
      },
      leaveChannel: (stats) {
        setState(() {
          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
          print(stats.duration.toString());
          _infoStrings.add('onLeaveChannel');
          print('llllllleeeeeeeeeeeeeffffffffffffttttttttt');
          _users.clear();
          _timer.cancel();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
          (widget.callStatus == 'o')
              ? CheckBalanceServices().checkaudiobalance()
              : null;

          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
          _stopWatchTimer.onChange;
          _timer = Timer.periodic(Duration(seconds: 59), (timer) {
            setState(() {
              print(
                  'hello after 5 secsssssssssssssssssssssssssssssssssss audio');
              (widget.callStatus == 'o')
                  ? CheckBalanceServices().checkaudiobalance().then((value) {
                      print(value['data']['status'].toString());
                      if (value['data']['status'].toString() == 'n') {
                        timer.cancel();
                        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                        _onCallEnd(context);
                      } else {}
                    })
                  : null;
            });
          });
          print(
              'iiiiiiiiiiiiiiiiiiiiiooooooooooooooooooooooooooooooooooooooooooooo');
        });
      },
      userOffline: (
        uid,
        elapsed,
      ) {
        setState(() {
          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
          _timer.cancel();
          print(StopWatchExecute.stop.toString());
          print(_stopWatchTimer.secondTime.toString() +
              'ccccccccccccaaaaaalllllllll');
          (widget.callStatus == 'o')
              ? OutgoingUserOffline()
              : IncomingUserOffline();
          final info = 'userOffline: $uid';
          _infoStrings.add(info);
          _users.remove(uid);
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideo: $uid ${width}x $height';
          _infoStrings.add(info);
        });
      },
    ));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];

    list.add(RtcLocalView.SurfaceView());

    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    _engine.leaveChannel();
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            //_panel(),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.CallerImage),
                radius: 150,
              ),
            ),
            _toolbar(),
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
                              color: Colors.white,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IncomingUserOffline() {
    NewCallServices().add_call(
        user_id: widget.user_id,
        call_duration: time,
        call_status: 'i',
        call_type: 'audio',
        caller_id: widget.caller_id);
    NewCallServices().add_call(
        user_id: widget.caller_id,
        call_duration: time,
        call_status: 'o',
        call_type: 'audio',
        caller_id: widget.user_id);
  }

  OutgoingUserOffline() {
    NewCallServices().add_call(
        user_id: widget.user_id,
        call_duration: time,
        call_status: 'o',
        call_type: 'audio',
        caller_id: widget.caller_id);
    NewCallServices().add_call(
        user_id: widget.caller_id,
        call_duration: time,
        call_status: 'i',
        call_type: 'audio',
        caller_id: widget.user_id);
  }
}
