import 'dart:convert';

import 'package:crush/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawInr extends StatefulWidget {
  const WithdrawInr({Key? key}) : super(key: key);

  @override
  _WithdrawInrState createState() => _WithdrawInrState();
}

class _WithdrawInrState extends State<WithdrawInr> {
  TextEditingController BnameCtl = TextEditingController();
  TextEditingController AccNoCtl = TextEditingController();
  TextEditingController IFSC_CODECtl = TextEditingController();
  TextEditingController HolderNameCtl = TextEditingController();
  TextEditingController AmountCtl = TextEditingController();
  var bankdata;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    get_bank_details().then((value) {
      setState(() {
        (value['status']) ? bankdata = value['data'] : bankdata = null;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                (bankdata == null)
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: appThemeColor),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: commonBtn(
                                        height: 40,
                                        s: 'Recently Used',
                                        bgcolor: Colors.transparent,
                                        textColor: appThemeColor,
                                        onPressed: () {},
                                      ),
                                    ),
                                    Expanded(
                                      child: commonBtn(
                                        height: 40,
                                        s: 'Select',
                                        bgcolor: appThemeColor,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            AccNoCtl.text =
                                                bankdata['account_number'];
                                            IFSC_CODECtl.text =
                                                bankdata['ifsc_code'];
                                            HolderNameCtl.text =
                                                bankdata['holder_name'];
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Bank Name: ',
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        bankdata['bank_name'],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Account Number: ',
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        bankdata['account_number'],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'IFSC Code: ',
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        bankdata['ifsc_code'],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Holder Name: ',
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        bankdata['holder_name'],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                enterField(
                  label: 'account_no',
                  ctl: AccNoCtl,
                ),
                enterField(
                  label: 'holder_name',
                  ctl: HolderNameCtl,
                ),
                enterField(
                  label: 'ifsc_code',
                  ctl: IFSC_CODECtl,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 8.0),
                  child: Text(
                    'Amount',
                    style: TextStyle(
                        fontFamily: 'SegoeUI',
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                enterField(
                  label: 'Withdraw_Amount',
                  ctl: AmountCtl,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonBtn(
                          width: 100,
                          s: 'Cancel',
                          bgcolor: Colors.white,
                          textColor: appThemeColor,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      commonBtn(
                          width: 200,
                          s: '\u{20B9} Withdraw',
                          bgcolor: appThemeColor,
                          textColor: Colors.white,
                          onPressed: () {
                            withdrawAmount();
                          }),
                    ],
                  ),
                )
              ],
            ),
            (loading)
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.withOpacity(0.3),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            height: 20, child: LinearProgressIndicator())))
                : Container()
          ],
        ),
      ),
    );
  }

  Future get_bank_details() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(
        Uri.parse(
            'https://crush.notionprojects.tech/api/get_contact_details.php'),
        body: {'token': '123456789', 'user_id': prefs.getString('user_id')});
    var Response = jsonDecode(response.body);
    print(Response);
    return Response;
  }

  Future withdrawAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
    });
    var response = await http.post(
        Uri.parse('https://crush.notionprojects.tech/api/wallet_withdrawl.php'),
        body: {
          'token': '123456789',
          'user_id': prefs.getString('user_id'),
          'ifsc_code': IFSC_CODECtl.text,
          'account_no': AccNoCtl.text,
          'deposit_amount': AmountCtl.text,
          'holder_name': HolderNameCtl.text,
        });
    var Response = jsonDecode(response.body);
    setState(() {
      (Response['status']) ? loading = false : loading = false;
    });

    print(Response);
    return Response;
  }
}

class enterField extends StatefulWidget {
  final String label;
  final double height;
  final double width;
  final TextEditingController ctl;
  const enterField({
    Key? key,
    required this.label,
    this.height = 50,
    this.width = double.infinity,
    required this.ctl,
  }) : super(key: key);

  @override
  State<enterField> createState() => _enterFieldState();
}

class _enterFieldState extends State<enterField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 50),
        child: TextField(
          controller: widget.ctl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            label: Text(widget.label),
            hintStyle: TextStyle(
                fontFamily: 'SegoeUI',
                fontWeight: FontWeight.w500,
                fontSize: 14),
            enabled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: new BorderSide(color: appThemeColor)),
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: new BorderSide(color: Colors.green)),
            hintText: '${widget.label}',
          ),
        ),
      ),
    );
  }
}
