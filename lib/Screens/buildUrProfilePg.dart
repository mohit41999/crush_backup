import 'package:crush/Constants/constants.dart';
import 'package:crush/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

import 'identifyYourselfPg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class BuildUrProfilePg extends StatefulWidget {
  final String user_id;
  const BuildUrProfilePg({Key? key, required this.user_id}) : super(key: key);

  @override
  State<BuildUrProfilePg> createState() => _BuildUrProfilePgState();
}

class _BuildUrProfilePgState extends State<BuildUrProfilePg> {
  bool isagree = false;
  Future _getpostImage() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var request = http.MultipartRequest(
          "POST",
          Uri.parse(
              "http://crush.notionprojects.tech/api/build_your_profile.php"));
      request.fields['user_id'] = widget.user_id;
      request.fields['token'] = '123456789';
      var pic =
          await http.MultipartFile.fromPath("profile_picture", image.path);
      request.files.add(pic);
      var response = await request.send();

      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
    } else {
      print('image not selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backgroundContainer(),
          Container(
            color: Colors.white.withOpacity(0.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(156),
                    ),
                    child: Icon(
                      Icons.account_circle_rounded,
                      size: 156,
                      color: appThemeColor.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                    width: 279,
                    height: 46,
                    child: Center(
                      child: Text(
                        'Build Your Profile',
                        style: TextStyle(
                          color: appThemeColor,
                          fontSize: 34,
                          fontFamily: 'SegoeUI',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                ),
                commonBtn(
                  bgcolor: appThemeColor,
                  s: (isagree) ? 'Next' : 'Add Your Photo',
                  onPressed: () {
                    (!isagree)
                        ? showDialog(
                            barrierColor: Colors.white.withOpacity(0.4),
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  actionsPadding: EdgeInsets.all(0),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(23, 20, 23, 2),
                                  titlePadding: EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: appThemeColor, width: 2),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                  title: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          'Crush Photo Guidelines ',
                                          style: TextStyle(
                                            fontSize: 21,
                                            color: appThemeColor,
                                            fontFamily: 'SegoeUI',
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: appThemeColor,
                                      ),
                                    ],
                                  ),
                                  buttonPadding: EdgeInsets.zero,
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ' - No kids on their own. They must be in the photo with an adult, and fully clothed.\n\n'
                                      ' - No photos in bikinis/swimwear indoors.\n\n'
                                      ' - No pictures in underwear.\n\n'
                                      ' - No Shirtless/underwear Mirror Selfies.\n\n'
                                      ' - Face must be clearly visible in all photos.\n\n'
                                      ' - No watermarks or text overlaid.\n\n'
                                      ' - No pornographic material.\n\n'
                                      ' - No graphic hunting photos.\n\n'
                                      ' - No guns.\n',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'SegoeUI',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: appThemeColor,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Refuse',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: appThemeColor,
                                                  fontFamily: 'SegoeUI',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 40,
                                            width: 102,
                                            decoration: BoxDecoration(
                                                color: appThemeColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: FlatButton(
                                                onPressed: () {
                                                  _getpostImage();
                                                  setState(() {
                                                    isagree = true;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Agree',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontFamily: 'SegoeUI',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IdentifyYourselgPg(
                                      user_id: widget.user_id,
                                    )));
                  },
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
