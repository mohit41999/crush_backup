import 'package:flutter/material.dart';

class backgroundContainer extends StatelessWidget {
  const backgroundContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/coupleimg.png'),
              fit: BoxFit.cover)),
    );
  }
}