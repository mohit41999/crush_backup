import 'package:crush/Constants/constants.dart';
import 'package:crush/Screens/verifyNumberPg.dart';
import 'package:crush/widgets/backgroundcontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backgroundContainer(),
          Container(
            color: Colors.white60.withOpacity(0.6),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Center(
                      child: Text(
                        'Crush',
                        style: TextStyle(
                          fontSize: 70,
                          color: appThemeColor,
                          fontFamily: 'PlaylistScript',
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Sign in to continue',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontFamily: 'SegoeUI',
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  // commonBtn(
                  //   bgcolor: appThemeColor,
                  //   s: 'Continue with Facebook',
                  //   onPressed: () {},
                  //   textColor: Colors.white,
                  // ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  commonBtn(
                    bgcolor: Colors.white,
                    s: 'Use Phone Number',
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => VerifyNumberPg()));
                    },
                    textColor: appThemeColor,
                  ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.15,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SizedBox(
                  //         width: MediaQuery.of(context).size.width * 0.22,
                  //         child: Divider(
                  //           thickness: 1,
                  //           color: Color(0xff707070).withOpacity(0.6),
                  //         )),
                  //     Padding(
                  //       padding: const EdgeInsets.all(13.0),
                  //       child: Text(
                  //         'or sign in with',
                  //         style: TextStyle(
                  //           fontFamily: 'SegoeUI',
                  //           letterSpacing: 1,
                  //           fontWeight: FontWeight.w600,
                  //           fontSize: 18,
                  //           color: Color(0xff707070).withOpacity(0.6),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //         width: MediaQuery.of(context).size.width * 0.22,
                  //         child: Divider(
                  //           thickness: 1,
                  //           color: Color(0xff707070).withOpacity(0.6),
                  //         ))
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.06,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Container(
                  //       height: 70,
                  //       width: 70,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(70),
                  //           border: Border.all(color: appThemeColor)),
                  //       child: Icon(
                  //         FontAwesomeIcons.facebookSquare,
                  //         size: 31.5,
                  //         color: appThemeColor,
                  //       ),
                  //     ),
                  //     Container(
                  //       height: 70,
                  //       width: 70,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(70),
                  //           border: Border.all(color: appThemeColor)),
                  //       child: Container(
                  //           width: 28.69,
                  //           height: 29.24,
                  //           child: Icon(
                  //             FontAwesomeIcons.google,
                  //             size: 31.5,
                  //             color: appThemeColor,
                  //           )),
                  //     ),
                  //     Container(
                  //       height: 70,
                  //       width: 70,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(70),
                  //           border: Border.all(color: appThemeColor)),
                  //       child: Icon(
                  //         FontAwesomeIcons.twitter,
                  //         size: 31.5,
                  //         color: appThemeColor,
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
