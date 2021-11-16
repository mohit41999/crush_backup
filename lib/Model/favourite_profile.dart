// To parse this JSON data, do
//
//     final favouriteProfile = favouriteProfileFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FavouriteProfile favouriteProfileFromJson(String str) =>
    FavouriteProfile.fromJson(json.decode(str));

String favouriteProfileToJson(FavouriteProfile data) =>
    json.encode(data.toJson());

class FavouriteProfile {
  FavouriteProfile({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory FavouriteProfile.fromJson(Map<String, dynamic> json) =>
      FavouriteProfile(
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
