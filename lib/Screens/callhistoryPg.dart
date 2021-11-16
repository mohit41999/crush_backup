import 'package:crush/Constants/constants.dart';
import 'package:crush/Model/callHistoryModel.dart';
import 'package:crush/Services/blockServices/blockservices.dart';
import 'package:crush/Services/callhistoryServices.dart';
import 'package:crush/widgets/backgroundcontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CallHistoryPg extends StatefulWidget {
  final String? user_id;
  const CallHistoryPg({Key? key, required this.user_id}) : super(key: key);

  @override
  _CallHistoryPgState createState() => _CallHistoryPgState();
}

class _CallHistoryPgState extends State<CallHistoryPg> {
  late CallHistoryModel callhistory;
  bool loading = true;
  late Future<CallHistoryModel> ch;

  @override
  void initState() {
    // TODO: implement initState
    ch = CallHistoryServices()
        .get_call_history(user_id: widget.user_id)
        .then((value) {
      setState(() {
        callhistory = value;
        loading = false;
      });
      return callhistory;
    });
    super.initState();
  }

  String month({required String month}) {
    switch (month) {
      case '01':
        return 'Jan';
      case '02':
        return 'Feb';
      case '03':
        return 'Mar';
      case '04':
        return 'Apr';
      case '05':
        return 'May';
      case '06':
        return 'Jun';
      case '07':
        return 'Jul';
      case '08':
        return 'Aug';
      case '09':
        return 'Sep';
      case '10':
        return 'Oct';
      case '11':
        return 'Nov';
      case '12':
        return 'Dec';
      default:
        return " ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ))
        : Scaffold(
            body: Stack(
              children: [
                backgroundContainer(),
                Container(
                  color: Colors.white.withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                          child: Text(
                            'Call History',
                            style: TextStyle(
                              color: appThemeColor,
                              fontSize: 20,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                reverse: true,
                                shrinkWrap: true,
                                itemCount: callhistory.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.all(0),
                                        leading: Icon(
                                          Icons.account_circle_rounded,
                                          color: Colors.grey,
                                          size: 50,
                                        ),
                                        title: Text(
                                          '${callhistory.data[index].fullName}',
                                          style: TextStyle(
                                            fontFamily: 'SegoeUI',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Icon(
                                              (callhistory.data[index]
                                                          .callStatus ==
                                                      'Incoming')
                                                  ? Icons.south_west
                                                  : Icons.north_east,
                                              color: (callhistory.data[index]
                                                          .callStatus ==
                                                      'Incoming')
                                                  ? Color(0xffFF4E4E)
                                                  : Color(0xff0FD97B),
                                              size: 15,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8.0, 0, 8),
                                              child: Text(callhistory
                                                      .data[index].callDateTime
                                                      .toString()
                                                      .substring(8, 10) +
                                                  " " +
                                                  month(
                                                      month: callhistory
                                                          .data[index]
                                                          .callDateTime
                                                          .toString()
                                                          .substring(5, 7)) +
                                                  " " +
                                                  callhistory
                                                      .data[index].callDateTime
                                                      .toString()
                                                      .substring(2, 4)),
                                            ),
                                          ],
                                        ),
                                        trailing: Wrap(
                                          spacing:
                                              18, // space between two icons
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                blockdialogunblock(
                                                    blockname: callhistory
                                                        .data[index].fullName,
                                                    blockid: callhistory
                                                        .data[index].callerId,
                                                    blocked: (callhistory
                                                                .data[index]
                                                                .blockStatus ==
                                                            'Yes')
                                                        ? 'Yes'
                                                        : 'No');
                                              },
                                              child: Text(
                                                (callhistory.data[index]
                                                            .blockStatus ==
                                                        'Yes')
                                                    ? 'UnBlock'
                                                    : 'Block',
                                                style: TextStyle(
                                                    color: Color(0xff0B0D0F)
                                                        .withOpacity(0.6),
                                                    fontSize: 12,
                                                    fontFamily: 'SegoeUI',
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                            Icon(
                                              Icons.block,
                                              color:
                                                  Colors.red.withOpacity(0.7),
                                              size: 15,
                                            ),

                                            Text(
                                              (callhistory.data[index]
                                                          .callDuration
                                                          .substring(0, 3)
                                                          .toString() ==
                                                      '00:')
                                                  ? '${callhistory.data[index].callDuration.substring(3, 8)}'
                                                  : '${callhistory.data[index].callDuration}',
                                              style: TextStyle(
                                                  color: Color(0xff0B0D0F)
                                                      .withOpacity(0.6),
                                                  fontSize: 12,
                                                  fontFamily: 'SegoeUI',
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            // Icon(
                                            //   Icons.block,
                                            //   color: Colors.red,
                                            // ), // icon-1
                                            Icon(
                                              (callhistory.data[index]
                                                          .callType ==
                                                      'video')
                                                  ? Icons.videocam_rounded
                                                  : Icons.call,
                                              color: appThemeColor,
                                            ), // icon-2
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                                  CallHistoryServices()
                                      .get_call_history(user_id: widget.user_id)
                                      .then((value) {
                                    setState(() {
                                      callhistory = value;
                                      // loading = false;
                                    });
                                    return callhistory;
                                  });
                                })
                              : BlockServices()
                                  .blockUser(blockid)
                                  .then((value) {
                                  CallHistoryServices()
                                      .get_call_history(user_id: widget.user_id)
                                      .then((value) {
                                    setState(() {
                                      callhistory = value;
                                      // loading = false;
                                    });
                                    return callhistory;
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
