import 'package:crush/Constants/constants.dart';
import 'package:crush/Model/favourite_profile.dart';
import 'package:crush/Model/home_usr_profile.dart';
import 'package:crush/Model/myAccountModel.dart';
import 'package:crush/Screens/reportUserPg.dart';
import 'package:crush/Services/blockServices/blockservices.dart';
import 'package:crush/Services/callRateServices.dart';
import 'package:crush/Services/checkbalanceServices/checkbalanceServices.dart';
import 'package:crush/Services/favourite_profileService.dart';
import 'package:crush/Services/generatechannelservices.dart';
import 'package:crush/Services/home_user_profile.dart';
import 'package:crush/Services/myAccountService.dart';
import 'package:crush/Services/sendnotification.dart';
import 'package:flutter/material.dart';

import '../firebase_notification_handler.dart';
import 'VideoCallPg.dart';
import 'VoiceCall.dart';

class UserPg extends StatefulWidget {
  final String selected_user_id;
  final String? user_id;
  final bool homeuser;
  const UserPg(
      {Key? key,
      required this.selected_user_id,
      required this.user_id,
      required this.homeuser})
      : super(key: key);

  @override
  _UserPgState createState() => _UserPgState();
}

class _UserPgState extends State<UserPg> {
  bool loading = true;
  bool loading2 = true;
  late Future<HomeUserProfile> homeuserprofile;
  late Future<FavouriteProfile> favourite;
  late Future<MyAccount> macc;
  late MyAccount myAccount;
  var user_profile;
  late String blockedd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlockServices()
        .checkblockeduser(selected_user_id: widget.selected_user_id)
        .then((value) {
      initialize();

      setState(() {
        (value['status']) ? blockedd = 'Yes' : blockedd = 'No';
        print(value.toString() + '00000000000000000000000');
      });
    });
    macc = myAccountService().get_myAccount(widget.user_id).then((value) {
      setState(() {
        myAccount = value;
        loading2 = true;
      });
      return myAccount;
    });
  }

  void initialize() {
    (widget.homeuser)
        ? homeuserprofile = HomeUserProfileService()
            .gethomeProfile(
                user_id: widget.selected_user_id, login_userID: widget.user_id)
            .then((value) {
            setState(() {
              user_profile = value;
              loading = false;
            });
            return user_profile;
          })
        : favourite = favouriteProfileService()
            .getfavouriteProfile(
            fav_id: widget.selected_user_id,
            login_userID: widget.user_id,
          )
            .then((value) {
            setState(() {
              user_profile = value;
              loading = false;
            });
            return user_profile;
          });
  }

  @override
  Widget build(BuildContext context) {
    return (loading && loading2)
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.yellow,
              ),
            ),
          )
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user_profile.data.fullName,
                    style: TextStyle(
                        color: appThemeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SegoeUI'),
                  ),
                  Center(
                      child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(user_profile.data.profileImage),
                    radius: 85,
                  )),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Age:-",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'SegoeUI',
                                  color: Color(0xff0B0D0F).withOpacity(0.6)),
                            )),
                            Expanded(
                                child: Text(user_profile.data.age,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'SegoeUI',
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff0B0D0F)))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "City:-",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'SegoeUI',
                                  color: Color(0xff0B0D0F).withOpacity(0.6),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Text(user_profile.data.city,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SegoeUI',
                                        color: Color(0xff0B0D0F)))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("Interested in:-",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'SegoeUI',
                                        color: Color(0xff0B0D0F)
                                            .withOpacity(0.6)))),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Men",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'SegoeUI',
                                          color: (user_profile.data.interested
                                                      .toString() ==
                                                  'men')
                                              ? appThemeColor
                                              : Color(0xff0B0D0F)
                                                  .withOpacity(0.6))),
                                  Text("Women",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'SegoeUI',
                                          color:
                                              (user_profile.data.interested ==
                                                      'women')
                                                  ? appThemeColor
                                                  : Color(0xff0B0D0F)
                                                      .withOpacity(0.6))),
                                  Text("Both",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'SegoeUI',
                                          color:
                                              (user_profile.data.interested ==
                                                      'both')
                                                  ? appThemeColor
                                                  : Color(0xff0B0D0F)
                                                      .withOpacity(0.6))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          alertbox(context, 'Audio');
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 40,
                          ),
                          decoration: BoxDecoration(
                              color: appThemeColor,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          alertbox(context, 'Video');
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          child: Icon(
                            Icons.videocam_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                              color: appThemeColor,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ReportUserPg(
                                          user_id: widget.user_id,
                                          selected_user_id:
                                              widget.selected_user_id,
                                        ))).then((value) {
                              setState(() {
                                initialize();
                              });
                            });
                          });
                        },
                        child: Text(
                          '${user_profile.data.reportStatus}',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: appThemeColor,
                              fontSize: 18,
                              fontFamily: 'SegoeUI'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          blockdialogunblock(
                              blockname: user_profile.data.fullName,
                              blockid: widget.selected_user_id,
                              blocked: blockedd);
                        },
                        child: Text(
                          (blockedd == 'Yes') ? 'Unblock' : 'Block',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: appThemeColor,
                              fontSize: 18,
                              fontFamily: 'SegoeUI'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Future alertbox(BuildContext context, String CallType) async {
    (CallType == 'Audio')
        ? CallRateServices().getAudiorate().then((value) {
            showDialog(
                barrierColor: Colors.white.withOpacity(0.4),
                context: context,
                builder: (BuildContext context) =>
                    commonalert(value, context, CallType));
          })
        : CallRateServices().getVideorate().then((value) {
            showDialog(
                barrierColor: Colors.white.withOpacity(0.4),
                context: context,
                builder: (BuildContext context) =>
                    commonalert(value, context, CallType));
          });
  }

  AlertDialog commonalert(value, BuildContext context, String callType) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: appThemeColor, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                gradient:
                    RadialGradient(colors: [Colors.orange, Colors.yellow]),
                borderRadius: BorderRadius.circular(50)),
            child: Icon(
              Icons.star_rounded,
              size: 20,
              color: Colors.yellowAccent.shade100,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                (callType == 'Audio')
                    ? value['data']['audio_call_rate']
                    : value['data']['video_call_rate'],
                style: TextStyle(
                    color: appThemeColor,
                    fontFamily: 'SegoeUI',
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    fontSize: 30),
              ),
              Text(
                ' / min',
                style: TextStyle(
                    color: Color(0xff0B0D0F).withOpacity(0.8),
                    fontFamily: 'SegoeUI',
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ],
          ),
          Text(
            (callType == 'Audio') ? 'For voice call' : 'For video call',
            style: TextStyle(
                color: Color(0xff0B0D0F).withOpacity(0.6),
                fontFamily: 'SegoeUI',
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
                fontSize: 14),
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'SegoeUI',
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        color: appThemeColor),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: 102,
                decoration: BoxDecoration(
                    color: appThemeColor,
                    borderRadius: BorderRadius.circular(5)),
                child: FlatButton(
                    onPressed: () {
                      CheckBlockUser()
                          .CheckBlock(widget.user_id, widget.selected_user_id)
                          .then((value) {
                        if (value['status']) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 1, milliseconds: 30),
                            backgroundColor: Colors.red,
                            content: Text(
                                user_profile.data.fullName.toString() +
                                    ' has blocked you'),
                          ));
                        } else {
                          (callType == 'Audio')
                              ? (double.parse(myAccount.data[0].total_coins) >=
                                      5)
                                  ? {
                                      generatechannel()
                                          .GenerateChannel(widget.user_id)
                                          .then((value) {
                                        setState(() {
                                          var cn =
                                              value['data']['Channel Name'];
                                          var profileImg =
                                              value['data']['Profile_image'];
                                          print(cn.toString() + '////////////');
                                          print(user_profile.data.fcm_token);
                                          sendnotification(
                                              cn,
                                              user_profile.data.fcm_token,
                                              '1',
                                              widget.user_id,
                                              widget.selected_user_id,
                                              profileImg);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VoiceCallPg(
                                                        caller_id: widget
                                                            .selected_user_id,
                                                        user_id: widget.user_id,
                                                        channelName: cn,
                                                        callStatus: 'o',
                                                        CallerImage:
                                                            user_profile.data
                                                                .profileImage,
                                                      ))).then((value) {
                                            Rejcted = false;
                                          });
                                        });
                                      })
                                    }
                                  : {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration: Duration(
                                            seconds: 1, milliseconds: 30),
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            'Not enough Coins for Audio call'),
                                      ))
                                    }
                              : (double.parse(myAccount.data[0].total_coins) >=
                                      10)
                                  ? {
                                      generatechannel()
                                          .GenerateChannel(widget.user_id)
                                          .then((value) {
                                        setState(() {
                                          var cn =
                                              value['data']['Channel Name'];
                                          var profileImg =
                                              value['data']['Profile_image'];
                                          print(cn.toString() + '////////////');
                                          print(user_profile.data.fcm_token);
                                          sendnotification(
                                              cn,
                                              user_profile.data.fcm_token,
                                              '0',
                                              widget.user_id,
                                              widget.selected_user_id,
                                              profileImg);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => VideoCallPage(
                                                      caller_id: widget
                                                          .selected_user_id,
                                                      user_id: widget.user_id,
                                                      channelName: cn,
                                                      callStatus: 'o',
                                                      CallerImage: user_profile
                                                          .data
                                                          .profileImage))).then(
                                              (value) {
                                            Rejcted = false;
                                          });
                                        });
                                      })
                                    }
                                  : {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration: Duration(
                                            seconds: 1, milliseconds: 30),
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            'Not enough Coins for Video call'),
                                      ))
                                    };
                        }
                      });
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SegoeUI',
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )),
              ),
            )
          ],
        )
      ],
    );
  }

  Future blockdialogunblock(
      {required String blockname,
      required String blockid,
      required String blocked}) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text((blocked == 'Yes')
                  ? 'Are you Sure You Want To Unblock ?'
                  : 'Are you Sure You Want To BLock ?'),
              content: Text(
                blockname.toUpperCase(),
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: commonBtn(
                        s: 'NO',
                        bgcolor: Colors.white,
                        textColor: appThemeColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        width: 70,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: commonBtn(
                        s: (blocked == 'Yes') ? 'Unblock' : 'Block',
                        bgcolor: appThemeColor,
                        textColor: Colors.white,
                        onPressed: () {
                          (blocked == 'Yes')
                              ? BlockServices()
                                  .unblockUser(blockid)
                                  .then((value) {
                                  BlockServices()
                                      .checkblockeduser(
                                          selected_user_id:
                                              widget.selected_user_id)
                                      .then((value) {
                                    setState(() {
                                      print(value.toString() +
                                          'ppppppppppppppppppppppp');
                                      (value['status'])
                                          ? blockedd = 'Yes'
                                          : blockedd = 'No';
                                    });
                                  });
                                })
                              : BlockServices()
                                  .blockUser(blockid)
                                  .then((value) {
                                  BlockServices()
                                      .checkblockeduser(
                                          selected_user_id:
                                              widget.selected_user_id)
                                      .then((value) {
                                    setState(() {
                                      print(value.toString() +
                                          'ppppppppppppppppppppppp');
                                      (value['status'])
                                          ? blockedd = 'Yes'
                                          : blockedd = 'No';
                                    });
                                  });
                                });
                          Navigator.pop(context);
                        },
                        width: 100,
                        height: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }
}
