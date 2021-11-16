// To parse this JSON data, do
//
//     final homeUserProfile = homeUserProfileFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

HomeUserProfile homeUserProfileFromJson(String str) =>
    HomeUserProfile.fromJson(json.decode(str));

String homeUserProfileToJson(HomeUserProfile data) =>
    json.encode(data.toJson());

class HomeUserProfile {
  HomeUserProfile({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory HomeUserProfile.fromJson(Map<String, dynamic> json) =>
      HomeUserProfile(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.fullName,
    required this.profileImage,
    required this.age,
    required this.city,
    required this.interested,
    required this.fcm_token,
    required this.reportStatus,
  });

  String fullName;
  String profileImage;
  String age;
  String city;
  String interested;
  String fcm_token;
  String reportStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        fullName: json["full_name"],
        profileImage: json["profile_image"],
        age: json["age"],
        city: json["city"],
        interested: json["interested"],
        fcm_token: json["fcm_token"],
        reportStatus: json["report_status"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "profile_image": profileImage,
        "age": age,
        "city": city,
        "interested": interested,
        "fcm_token": fcm_token,
        "report_status": reportStatus,
      };
}
