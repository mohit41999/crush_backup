import 'dart:convert';

import 'package:crush/Constants/constants.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:crush/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'generalHomeScreen.dart';
import 'infoPg.dart';

class InterestPg extends StatefulWidget {
  final String user_id;
  const InterestPg({Key? key, required this.user_id}) : super(key: key);

  @override
  _InterestPgState createState() => _InterestPgState();
}

class _InterestPgState extends State<InterestPg> {
  late String gender;
  Future Interested() async {
    var Response = await http
        .post(Uri.parse(BASE_URL + AppConstants.INTERESTED), body: {
      'token': '123456789',
      'user_id': widget.user_id,
      'interested': gender
    });
    var response = jsonDecode(Response.body);
    if (response['status']) {
      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GeneralHomeScreen(
                      user_id: widget.user_id,
                    )));
      });
    }
  }

  bool ismaleSelected = false;
  bool isfemaleSelected = false;
  bool isbothSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          backgroundContainer(),
          Container(
            color: Colors.white.withOpacity(0.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Who are you Interested In ?',
                    style: TextStyle(
                      color: appThemeColor,
                      fontSize: 40,
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = 'men';
                        ismaleSelected = true;
                        isfemaleSelected = false;
                        isbothSelected = false;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color:
                                (ismaleSelected) ? appThemeColor : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: (ismaleSelected)
                                    ? Colors.white
                                    : appThemeColor)),
                        height: 50,
                        width: 250,
                        child: Center(
                          child: Text(
                            'Men',
                            style: TextStyle(
                              color: (ismaleSelected)
                                  ? Colors.white
                                  : appThemeColor,
                              fontSize: 18,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = 'women';
                        ismaleSelected = false;
                        isfemaleSelected = true;
                        isbothSelected = false;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: (isfemaleSelected)
                                ? appThemeColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: (isfemaleSelected)
                                    ? Colors.white
                                    : appThemeColor)),
                        height: 50,
                        width: 250,
                        child: Center(
                          child: Text(
                            'Women',
                            style: TextStyle(
                              color: (isfemaleSelected)
                                  ? Colors.white
                                  : appThemeColor,
                              fontSize: 18,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = 'both';
                        ismaleSelected = false;
                        isfemaleSelected = false;
                        isbothSelected = true;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color:
                                (isbothSelected) ? appThemeColor : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: (isbothSelected)
                                    ? Colors.white
                                    : appThemeColor)),
                        height: 50,
                        width: 250,
                        child: Center(
                          child: Text(
                            'Both',
                            style: TextStyle(
                              color: (isbothSelected)
                                  ? Colors.white
                                  : appThemeColor,
                              fontSize: 18,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                Center(
                  child: commonBtn(
                    bgcolor: appThemeColor,
                    s: 'Done',
                    textColor: Colors.white,
                    onPressed: () {
                      Interested();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
