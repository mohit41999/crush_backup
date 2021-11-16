// To parse this JSON data, do
//
//     final identifyYourself = identifyYourselfFromJson(jsonString);

import 'dart:convert';

IdentifyYourself identifyYourselfFromJson(String str) =>
    IdentifyYourself.fromJson(json.decode(str));

String identifyYourselfToJson(IdentifyYourself data) =>
    json.encode(data.toJson());

class IdentifyYourself {
  IdentifyYourself({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  String data;

  factory IdentifyYourself.fromJson(Map<String, dynamic> json) =>
      IdentifyYourself(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}
