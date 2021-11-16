// To parse this JSON data, do
//
//     final coins = coinsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Coins coinsFromJson(String str) => Coins.fromJson(json.decode(str));

String coinsToJson(Coins data) => json.encode(data.toJson());

class Coins {
  Coins({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<coinsData> data;

  factory Coins.fromJson(Map<String, dynamic> json) => Coins(
        status: json["status"],
        message: json["message"],
        data: List<coinsData>.from(
            json["data"].map((x) => coinsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class coinsData {
  coinsData({
    required this.planName,
    required this.totalCoin,
    required this.amount,
    required this.user_total_coins,
  });

  String planName;
  String user_total_coins;
  String totalCoin;
  String amount;

  factory coinsData.fromJson(Map<String, dynamic> json) => coinsData(
        planName: json["plan_name"],
        totalCoin: json["total_coin"],
        amount: json["amount"],
        user_total_coins: json["user_total_coins"],
      );

  Map<String, dynamic> toJson() => {
        "plan_name": planName,
        "total_coin": totalCoin,
        "amount": amount,
        "user_total_coins": user_total_coins,
      };
}
