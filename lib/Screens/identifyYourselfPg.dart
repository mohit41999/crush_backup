import 'package:crush/Constants/constants.dart';
import 'package:crush/Model/identifyYourSelfModel.dart';
import 'package:crush/Screens/recoveryEmailPg.dart';
import 'package:crush/Services/identify_yourself_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';

import 'buildUrProfilePg.dart';

class IdentifyYourselgPg extends StatefulWidget {
  final String user_id;
  const IdentifyYourselgPg({Key? key, required this.user_id}) : super(key: key);

  @override
  _IdentifyYourselgPgState createState() => _IdentifyYourselgPgState();
}

class _IdentifyYourselgPgState extends State<IdentifyYourselgPg> {
  TextEditingController namecontroller = TextEditingController();
  String Day = "DD";
  String Month = "MM";
  String Year = "YYYY";
  String countryValue = DefaultCountry.India.toString();
  String? stateValue = '';
  String? cityValue = '';
  bool ismaleSelected = false;
  bool isfemaleSelected = false;
  late String gender;
  late String name;
  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        Day = currentDate.day.toString();
        Year = currentDate.year.toString();
        Month = currentDate.month.toString();

        print(currentDate);
      });
  }

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
                  child: Text(
                    'Identify Yourself',
                    style: TextStyle(
                      color: appThemeColor,
                      fontSize: 40,
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 23, 0, 23),
                  child: Text(
                    'I am a',
                    style: TextStyle(
                      color: appThemeColor,
                      fontSize: 18,
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          ismaleSelected = true;
                          isfemaleSelected = false;
                          gender = 'm';
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: (ismaleSelected)
                                  ? appThemeColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: (ismaleSelected)
                                      ? Colors.white
                                      : appThemeColor)),
                          height: 50,
                          width: 160,
                          child: Center(
                            child: Text(
                              'Male',
                              style: TextStyle(
                                  color: (ismaleSelected)
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily: 'SegoeUI',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isfemaleSelected = true;
                          ismaleSelected = false;
                          gender = 'f';
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
                          width: 160,
                          child: Center(
                            child: Text(
                              'Female',
                              style: TextStyle(
                                  color: (isfemaleSelected)
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily: 'SegoeUI',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 39,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Other Options',
                      style: TextStyle(
                        fontSize: 22,
                        color: appThemeColor,
                        fontFamily: 'SegoeUI',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.49,
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: appThemeColor,
                      size: 22,
                    )
                  ],
                ),
                SizedBox(
                  height: 39,
                ),
                Text(
                  'Birthday',
                  style: TextStyle(
                    color: appThemeColor,
                    fontSize: 18,
                    fontFamily: 'SegoeUI',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        width: 87,
                        decoration: BoxDecoration(
                            border: Border.all(color: appThemeColor),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            Day,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 87,
                        decoration: BoxDecoration(
                            border: Border.all(color: appThemeColor),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            Month,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 129,
                        decoration: BoxDecoration(
                            border: Border.all(color: appThemeColor),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            Year,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                Text(
                  'Name',
                  style: TextStyle(
                    color: appThemeColor,
                    fontSize: 18,
                    fontFamily: 'SegoeUI',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                TextField(
                  controller: namecontroller,
                  onChanged: (value) {
                    value = namecontroller.text.toString();
                    name = value;
                  },
                  onSubmitted: (value) {
                    value = namecontroller.text.toString();
                    name = value;
                  },
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.w500,
                    ),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: new BorderSide(color: appThemeColor)),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: appThemeColor)),
                    hintText: 'Add your name here',
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                CSCPicker(
                  defaultCountry: DefaultCountry.India,
                  showCities: true,
                  flagState: CountryFlag.DISABLE,
                  dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),
                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade300,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),
                  selectedItemStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  dropdownHeadingStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  dropdownItemStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  dropdownDialogRadius: 10.0,
                  searchBarRadius: 10.0,
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                      print(countryValue);
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                ),
                SizedBox(
                  height: 26,
                ),
                Center(
                  child: commonBtn(
                    bgcolor: appThemeColor,
                    s: 'Continue',
                    textColor: Colors.white,
                    onPressed: () {
                      IdentifyYourself response;
                      print(name);
                      name = name;

                      IdentifyYrSelfServices()
                          .postIdentifyYourself(
                              gender,
                              '${Year.toString()}-${Month.toString()}-${Day.toString()}',
                              name.toString(),
                              cityValue.toString(),
                              widget.user_id)
                          .then((value) {
                        response = value;
                        print(response.status);
                        print(response);
                        if (response.status) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecoveryEmailPg(
                                        user_id: widget.user_id,
                                      )));
                        }
                        return response;
                      });
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
