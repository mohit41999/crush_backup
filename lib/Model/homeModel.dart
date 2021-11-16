// To parse this JSON data, do
//
//     final home = homeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Home homeFromJson(String str) => Home.fromJson(json.decode(str));

String homeToJson(Home data) => json.encode(data.toJson());

class Home {
  Home({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory Home.fromJson(Map<String, dynamic> json) => Home(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum(
      {required this.userId,
      required this.fullName,
      required this.profileImage,
      required this.age,
      required this.city,
      required this.gender,
      required this.status,
      required this.mobile_number,
      required this.fcm_token});

  String userId;
  String fullName;
  String profileImage;
  String age;
  String city;
  String gender;
  dynamic status;
  String mobile_number;
  String fcm_token;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["user_id"],
        fullName: json["full_name"],
        profileImage: json["profile_image"],
        age: json["age"],
        city: json["city"],
        gender: json["gender"],
        status: json["status"],
        mobile_number: json["mobile_number"],
        fcm_token: json["fcm_token"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "full_name": fullName,
        "profile_image": profileImage,
        "age": age,
        "city": city,
        "gender": gender,
        "status": status,
        "mobile_number": mobile_number,
        "fcm_token": fcm_token,
      };
}
