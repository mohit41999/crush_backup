// To parse this JSON data, do
//
//     final getFavUsers = getFavUsersFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetFavUsers getFavUsersFromJson(String str) =>
    GetFavUsers.fromJson(json.decode(str));

String getFavUsersToJson(GetFavUsers data) => json.encode(data.toJson());

class GetFavUsers {
  GetFavUsers({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory GetFavUsers.fromJson(Map<String, dynamic> json) => GetFavUsers(
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
  Datum({
    required this.userId,
    required this.fullName,
    required this.profilePicture,
  });

  String userId;
  String fullName;
  dynamic profilePicture;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["user_id"],
        fullName: json["full_name"],
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "full_name": fullName,
        "profile_picture": profilePicture,
      };
}
