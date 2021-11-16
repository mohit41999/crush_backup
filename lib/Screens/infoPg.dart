import 'package:crush/Constants/constants.dart';
import 'package:flutter/material.dart';

import 'interestPg.dart';

class InfoPg extends StatelessWidget {
  final String user_id;
  const InfoPg({Key? key, required this.user_id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appThemeColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Crush',
              style: TextStyle(
                fontSize: 70,
                color: Colors.white,
                fontFamily: 'PlaylistScript',
              ),
            ),
          ),
          SizedBox(
            height: 51,
          ),
          Center(
            child: Text('Everything You\'re Looking For\n Is Here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontFamily: 'SegoeUI',
                  fontWeight: FontWeight.w500,
                )),
          ),
          SizedBox(
            height: 238,
          ),
          Center(
            child: commonBtn(
              bgcolor: Colors.white,
              s: 'Continue',
              textColor: appThemeColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InterestPg(
                              user_id: user_id,
                            )));
              },
            ),
          ),
        ],
      ),
    );
    ;
  }
}
