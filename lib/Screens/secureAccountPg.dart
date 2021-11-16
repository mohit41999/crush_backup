import 'dart:convert';

import 'package:crush/Constants/constants.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'infoPg.dart';

class SecureAccountPg extends StatefulWidget {
  final String user_id;
  const SecureAccountPg({Key? key, required this.user_id}) : super(key: key);

  @override
  _SecureAccountPgState createState() => _SecureAccountPgState();
}

class _SecureAccountPgState extends State<SecureAccountPg> {
  late String userName;
  late String password;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future addUserPass(String userName, String password) async {
    var Response = await http
        .post(Uri.parse(BASE_URL + AppConstants.SECURE_ACC_EMAIL), body: {
      'token': '123456789',
      'user_id': widget.user_id,
      'username': userName,
      'password': password
    });
    var response = jsonDecode(Response.body);
    print(response);
    if (response['status']) {
      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InfoPg(user_id: widget.user_id)));
      });
    }
  }

  bool boolpass = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 106,
                    width: 262,
                    child: Text(
                      'Secure Your Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: appThemeColor,
                        fontSize: 40,
                        fontFamily: 'SegoeUI',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 400,
                      height: 73,
                      child: Text(
                        'Create your password using 8 characters or, more. It can be any combination of letters, numbers and symbols..',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff0B0D0F).withOpacity(0.6),
                          fontFamily: 'SegoeUI',
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  'Username',
                  style: TextStyle(
                    color: appThemeColor,
                    fontSize: 18,
                    fontFamily: 'SegoeUI',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                TextField(
                  controller: userNameController,
                  onChanged: (value) {
                    setState(() {
                      print('change${userNameController.text.toString()}');
                      value = userNameController.text.toString();
                      userName = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      print('submit${userNameController.text.toString()}');
                      value = userNameController.text.toString();
                      userName = value;
                    });
                  },
                  decoration: InputDecoration(
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: new BorderSide(color: appThemeColor)),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: appThemeColor)),
                    hintTextDirection: TextDirection.ltr,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: '   username',
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  'Password',
                  style: TextStyle(color: appThemeColor, fontSize: 18),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                TextField(
                  obscureText: boolpass,
                  controller: passwordController,
                  onChanged: (value) {
                    setState(() {
                      print('change${passwordController.text.toString()}');
                      print(widget.user_id);
                      value = passwordController.text.toString();
                      password = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      print('submit${passwordController.text.toString()}');
                      value = passwordController.text.toString();
                      password = value;
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: (boolpass)
                            ? Icon(
                                FontAwesomeIcons.eyeSlash,
                                size: 18,
                              )
                            : Icon(
                                FontAwesomeIcons.eye,
                                size: 18,
                              ),
                        onPressed: () {
                          setState(() {
                            (boolpass) ? boolpass = false : boolpass = true;
                          });
                        },
                        color: appThemeColor,
                      ),
                    ),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: new BorderSide(color: appThemeColor)),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: appThemeColor)),
                    hintTextDirection: TextDirection.ltr,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: '    password',
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Center(
                  child: commonBtn(
                    bgcolor: appThemeColor,
                    s: 'Done',
                    textColor: Colors.white,
                    onPressed: () {
                      addUserPass(userName, password);
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
