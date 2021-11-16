import 'dart:convert';
import 'dart:io';

import 'package:crush/Constants/constants.dart';
import 'package:crush/widgets/backgroundcontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RazorPay extends StatefulWidget {
  const RazorPay({Key? key}) : super(key: key);

  @override
  _RazorPayState createState() => _RazorPayState();
}

class _RazorPayState extends State<RazorPay> {
  late Razorpay _razorpay;

  var user_id;

  @override
  void dispose() {
    _razorpay.clear();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> depositsuccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');

    var Response = await http.post(
        Uri.parse('http://crush.notionprojects.tech/api/INR_deposit.php'),
        body: {
          'token': '123456789',
          'user_id': user_id,
          'amount': payamount.text.toString(),
        });
    var response = jsonDecode(Response.body);
    print(response);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    depositsuccess();
    print('order' + response.orderId.toString());
    print('paymentId' + response.paymentId.toString());
    print('signature' + response.signature.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // TODO: implement initState
    super.initState();
  }

  String username = 'rzp_test_XZiANpd7i5zBJo';
  String password = 'nf5Mxscuk78JAsKLFVVY9dY2';

  TextEditingController payamount = TextEditingController();
  void payment(String amount) async {
    final client = HttpClient();

    final request =
        await client.postUrl(Uri.parse('https://api.razorpay.com/v1/orders'));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('${username}:${password}'));
    request.headers.set(HttpHeaders.authorizationHeader, basicAuth);
    Object? orderOptions = {
      "amount": amount,
      "currency": "INR",
      "receipt": "Receipt no. 1",
      "payment_capture": 1,
      "notes": {
        "notes_key_1": "Tea, Earl Grey, Hot",
        "notes_key_2": "Tea, Earl Grey… decaf."
      }
    };
    request.add(utf8.encode(json.encode(orderOptions)));
    final response = await request.close();
    response.transform(utf8.decoder).listen((contents) {
      String orderId = contents.split(',')[0].split(":")[1];
      orderId = orderId.substring(1, orderId.length - 1);

      Map<String, dynamic> checkoutOptions = {
        'key': username,
        'amount': amount,
        "currency": "INR",
        'name': 'E Drives',
        'description': 'E Bike',
        'order_id': orderId, // Generate order_id using Orders API
        'timeout': 300,
      };
      try {
        _razorpay.open(checkoutOptions);
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
              child: Text(
                'Amount',
                style: TextStyle(
                    fontFamily: 'SegoeUI',
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 50),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: payamount,
                  onChanged: (value) {
                    value = payamount.text.toString();
                  },
                  onSubmitted: (value) {
                    value = payamount.text.toString();
                  },
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        fontFamily: 'SegoeUI',
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: new BorderSide(color: appThemeColor)),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: appThemeColor)),
                    hintText: 'Enter Amount',
                  ),
                ),
              ),
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
                      s: '\u{20B9} Pay',
                      bgcolor: appThemeColor,
                      textColor: Colors.white,
                      onPressed: () {
                        payment(payamount.text.toString() + "00");
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
