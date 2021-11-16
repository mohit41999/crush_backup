import 'dart:ui';
import 'package:crush/Constants/constants.dart';
import 'package:crush/Model/homeModel.dart';
import 'package:crush/Model/myAccountModel.dart';
import 'package:crush/Screens/VoiceCall.dart';
import 'package:crush/Screens/userPg.dart';
import 'package:crush/Services/callRateServices.dart';
import 'package:crush/Services/checkbalanceServices/checkbalanceServices.dart';
import 'package:crush/Services/generatechannelservices.dart';
import 'package:crush/Services/homeServices.dart';
import 'package:crush/Services/myAccountService.dart';
import 'package:crush/Services/sendnotification.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../firebase_notification_handler.dart';
import 'VideoCallPg.dart';

class HomePg extends StatefulWidget {
  final String? user_id;
  const HomePg({Key? key, required this.user_id}) : super(key: key);

  @override
  _HomePgState createState() => _HomePgState();
}

class _HomePgState extends State<HomePg> {
  bool loading = false;
  bool loading2 = false;
  late Future<Home> home;
  late Future<MyAccount> macc;
  late Home gethomeDetails;
  late MyAccount myAccount;
  int startIndex = 0;
  late String cn;


  Future addFavourites(String fav_id) async {
    var response = await http
        .post(Uri.parse(BASE_URL + AppConstants.ADD_FAVOURITES), body: {
      'token': '123456789',
      'user_id': widget.user_id,
      'fav_user_id': fav_id
    });
    if (response.statusCode == 200 &&
        startIndex < gethomeDetails.data.length - 1) {
      setState(() {
        startIndex++;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    home = HomeService().getHomeDetails(widget.user_id).then((value) {
      setState(() {
        gethomeDetails = value;
        loading = true;
      });
      return gethomeDetails;
    });
    macc = myAccountService().get_myAccount(widget.user_id).then((value) {
      setState(() {
        myAccount = value;
        loading2 = true;
      });
      return myAccount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (!loading && !loading2)
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          gethomeDetails.data[startIndex].profileImage),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            (gethomeDetails.data[startIndex].status
                                        .toString() ==
                                    'Online')
                                ? 'Online  '
                                : 'Offline  ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            Icons.circle,
                            color: (gethomeDetails.data[startIndex].status
                                        .toString() ==
                                    'Online')
                                ? Color(0xff0FD97B)
                                : Colors.red,
                            size: 10,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserPg(
                                        homeuser: true,
                                        user_id: widget.user_id,
                                        selected_user_id: gethomeDetails
                                            .data[startIndex].userId)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${gethomeDetails.data[startIndex].fullName}, ${gethomeDetails.data[startIndex].age}',
                              style: TextStyle(
                                color: Color(0xffF0EEEF),
                                fontSize: 22,
                                fontFamily: 'SegoeUI',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Icon(Icons.location_on,
                                  size: 20, color: Colors.grey),
                            ),
                            Text(
                              '${gethomeDetails.data[startIndex].city}',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (startIndex <
                                      gethomeDetails.data.length - 1) {
                                    setState(() {
                                      startIndex++;
                                      print(gethomeDetails.data.length
                                          .toString());
                                    });
                                  }
                                },
                                child: homeIconBtn(
                                  icon: Icons.close,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  alertbox(context, 'Audio');
                                },
                                child: homeIconBtn(
                                  icon: Icons.call,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  alertbox(context, 'Video');
                                },
                                child: homeIconBtn(
                                  icon: Icons.videocam,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  addFavourites(
                                      gethomeDetails.data[startIndex].userId);
                                },
                                child: homeIconBtn(
                                  icon: Icons.favorite,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
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
                          .CheckBlock(widget.user_id,
                              gethomeDetails.data[startIndex].userId)
                          .then((value) {
                        (value['status']);
                        if (value['status']) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 1, milliseconds: 30),
                            backgroundColor: Colors.red,
                            content: Text(gethomeDetails
                                    .data[startIndex].fullName
                                    .toString() +
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
                                          cn = value['data']['Channel Name'];
                                          var profileImg =
                                              value['data']['Profile_image'];
                                          print(cn.toString() + '////////////');
                                          sendnotification(
                                              cn,
                                              gethomeDetails
                                                  .data[startIndex].fcm_token,
                                              '1',
                                              widget.user_id,
                                              gethomeDetails
                                                  .data[startIndex].userId,
                                              profileImg);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VoiceCallPg(
                                                        caller_id:
                                                            gethomeDetails
                                                                .data[
                                                                    startIndex]
                                                                .userId,
                                                        user_id: widget.user_id,
                                                        channelName: cn,
                                                        callStatus: 'o',
                                                        CallerImage:
                                                            gethomeDetails
                                                                .data[
                                                                    startIndex]
                                                                .profileImage,
                                                      ))).then(
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
                                          cn = value['data']['Channel Name'];
                                          var profileImg =
                                              value['data']['Profile_image'];
                                          print(cn.toString() + '////////////');
                                          sendnotification(
                                              cn,
                                              gethomeDetails
                                                  .data[startIndex].fcm_token,
                                              '0',
                                              widget.user_id,
                                              gethomeDetails
                                                  .data[startIndex].userId,
                                              profileImg);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => VideoCallPage(
                                                      caller_id: gethomeDetails
                                                          .data[startIndex]
                                                          .userId,
                                                      user_id: widget.user_id,
                                                      channelName: cn,
                                                      callStatus: 'o',
                                                      CallerImage: gethomeDetails
                                                          .data[startIndex]
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
}
