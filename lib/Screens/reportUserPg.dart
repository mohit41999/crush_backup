import 'dart:convert';

import 'package:crush/Constants/constants.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportUserPg extends StatefulWidget {
  final String? user_id;
  final String selected_user_id;
  const ReportUserPg(
      {Key? key, required this.user_id, required this.selected_user_id})
      : super(key: key);

  @override
  _ReportUserPgState createState() => _ReportUserPgState();
}

class _ReportUserPgState extends State<ReportUserPg> {
  TextStyle reportText =
      TextStyle(color: Color(0xff0B0D0F).withOpacity(0.8), fontSize: 16);
  List Reasons = [
    'It\'s spam',
    'I just don\'t like it',
    'Eating disorder',
    'Sale of illegal or regulated goods',
    'Suicide or injury',
    'Intellectual property violation',
    'Scam or fraud',
    'Nudity or sexual activity',
    'Hate speech or symbols',
    'Violence or dangerous organisations',
    'False informations',
    'Bullying or harassment',
    'Something else',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Report',
              style: TextStyle(
                  color: appThemeColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text('Why are you reporting this post ?',
                style: TextStyle(fontSize: 16)),
            Text(
              'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea.',
              style: TextStyle(
                  color: Color(0xff0B0D0F).withOpacity(0.6), fontSize: 14),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Reasons.length,
                  itemBuilder: (BuildContext, int index) {
                    return GestureDetector(
                      onTap: () {
                        alertBox(Reasons[index]);
                      },
                      child: Text(
                        Reasons[index] + "\n",
                        style: reportText,
                        textAlign: TextAlign.left,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future reportUser(String reason) async {
    var response =
        await http.post(Uri.parse(BASE_URL + AppConstants.REPORT_USER), body: {
      'token': '123456789',
      'user_id': widget.user_id,
      'reported_user_id': widget.selected_user_id,
      'reason': reason
    });
    var Response = jsonDecode(response.body);
    print(Response);
  }

  void alertBox(String reason) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Are you want to report user?\n${reason}'),
            title: Text('Report User'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  commonBtn(
                      s: 'No',
                      height: 40,
                      width: 60,
                      bgcolor: Colors.red,
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  commonBtn(
                      s: 'Yes',
                      height: 40,
                      width: 60,
                      bgcolor: Colors.green,
                      textColor: Colors.black,
                      onPressed: () {
                        reportUser(reason);
                        Navigator.pop(context);
                      }),
                ],
              )
            ],
          );
        });
  }
}
