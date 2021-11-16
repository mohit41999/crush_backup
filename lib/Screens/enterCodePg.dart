import 'dart:convert';
import 'package:crush/Constants/constants.dart';
import 'package:crush/Services/fcmServices.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:crush/widgets/backgroundcontainer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'buildUrProfilePg.dart';
import 'generalHomeScreen.dart';

class EnterCodePg extends StatefulWidget {
  final String mobileNumber;
  final bool exists;
  final String user_id;
  const EnterCodePg(
      {Key? key,
      required this.mobileNumber,
      required this.user_id,
      required this.exists})
      : super(key: key);

  @override
  _EnterCodePgState createState() => _EnterCodePgState();
}

class _EnterCodePgState extends State<EnterCodePg> {
  TextEditingController otpController = TextEditingController();
  late String OTP;

  late FirebaseMessaging _getfcmtoken;

  Future setprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phonenumber', widget.mobileNumber.toString());
    prefs.setString('user_id', widget.user_id.toString());
  }

  Future verifyOtp() async {
    var Response = await http
        .post(Uri.parse(BASE_URL + AppConstants.VERIFY_OTP), body: {
      'token': '123456789',
      'mobile_number': '${widget.mobileNumber}',
      'otp': OTP
    });
    var response = jsonDecode(Response.body);
    print(response);
    print(widget.mobileNumber);
    print(response['status']);
    (response['status'])
        ? (!widget.exists)
            ? setprefs().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => GeneralHomeScreen(
                              user_id: widget.user_id,
                            )));
              })
            : setprefs().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BuildUrProfilePg(
                              user_id: widget.user_id,
                            )));
              })
        : print('false');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getfcmtoken = FirebaseMessaging.instance;

    _getfcmtoken.getToken().then((value) {
      Fcm_Services().sendfcm(widget.user_id, value!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          backgroundContainer(),
          Container(
            color: Colors.white.withOpacity(0.6),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            'Enter Your Code ',
                            style: TextStyle(
                              color: appThemeColor,
                              fontSize: 40,
                              fontFamily: 'SegoeUI',
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Enter 4-digit code',
                            style: TextStyle(
                              color: Color(0xff0B0D0F),
                              fontSize: 16,
                              fontFamily: 'SegoeUI',
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: PinCodeTextField(
                              onChanged: (value) {
                                setState(() {
                                  value = otpController.text.toString();
                                  OTP = value;
                                  print(value);
                                });
                              },
                              controller: otpController,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.white,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontFamily: 'SegoeUI',
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                              ),
                              autoDismissKeyboard: false,
                              pinTheme: PinTheme(
                                  inactiveColor: appThemeColor,
                                  activeColor: Colors.white,
                                  fieldHeight: 70,
                                  fieldWidth: 60,
                                  activeFillColor: appThemeColor,
                                  inactiveFillColor: Colors.white,
                                  selectedFillColor: appThemeColor,
                                  borderWidth: 1,
                                  borderRadius: BorderRadius.circular(5),
                                  shape: PinCodeFieldShape.box,
                                  selectedColor: Colors.white),
                              onSubmitted: (value) {
                                setState(() {
                                  value = otpController.text.toString();
                                  OTP = value;
                                  print(value);
                                });
                              },
                              appContext: context,
                              length: 4,
                              enableActiveFill: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: commonBtn(
                        s: 'Continue  ',
                        bgcolor: appThemeColor,
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            verifyOtp();
                          });
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
