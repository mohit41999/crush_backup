import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color appThemeColor = Color(0xff0E72EC);

class commonBtn extends StatelessWidget {
  final String s;
  final Color bgcolor;
  final Color textColor;
  final VoidCallback onPressed;
  final double height;
  final double width;
  const commonBtn({
    Key? key,
    required this.s,
    required this.bgcolor,
    required this.textColor,
    required this.onPressed,
    this.height = 50,
    this.width = 320,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(bgcolor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ))),
        onPressed: onPressed,
        child: Text(
          s,
          style: TextStyle(
              fontSize: 18,
              color: textColor,
              fontFamily: 'SegoeUI',
              letterSpacing: 1,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class columnWidget extends StatefulWidget {
  const columnWidget({Key? key}) : super(key: key);

  @override
  _columnWidgetState createState() => _columnWidgetState();
}

class _columnWidgetState extends State<columnWidget> {
  bool ageSwitch = false;

  @override
  Widget build(BuildContext context) {
    var ageBetween;
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Age'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Between ${ageBetween.start.round().toString()} & ${ageBetween.end.round().toString()}'),
            ),
            RangeSlider(
              activeColor: appThemeColor,
              values: ageBetween,
              divisions: 3,
              min: 0,
              max: 100,
              //divisions: 5,
              labels: RangeLabels(
                ageBetween.start.round().toString(),
                ageBetween.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  ageBetween = values;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('See people 2 years either side if I run out'),
                  CupertinoSwitch(
                      value: ageSwitch,
                      onChanged: (value) {
                        setState(() {
                          ageSwitch = value;
                        });
                      })
                ],
              ),
            )
          ],
        ),
        Column(
          children: [
            Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 6,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('images/wallpaper.jpg'))),
                        ),
                      );
                    })),
          ],
        )
      ],
    );
  }
}

class homeIconBtn extends StatelessWidget {
  final IconData icon;
  const homeIconBtn({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white54, width: 1)),
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Center(
                  child: Icon(
                icon,
                color: Colors.white,
                size: 40,
              )),
            ),
          ),
        ));
  }
}
