// To parse this JSON data, do
//
//     final callHistoryModel = callHistoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CallHistoryModel callHistoryModelFromJson(String str) =>
    CallHistoryModel.fromJson(json.decode(str));

String callHistoryModelToJson(CallHistoryModel data) =>
    json.encode(data.toJson());

class CallHistoryModel {
  CallHistoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory CallHistoryModel.fromJson(Map<String, dynamic> json) =>
      CallHistoryModel(
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
    required this.callerId,
    required this.fullName,
    required this.callType,
    required this.callDuration,
    required this.callStatus,
    required this.blockStatus,
    required this.callDateTime,
  });

  String userId;
  String callerId;
  String fullName;
  String callType;
  String callDuration;
  String callStatus;
  String blockStatus;
  dynamic callDateTime;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["user_id"],
        callerId: json["caller_id"],
        fullName: json["full_name"],
        callType: json["call_type"],
        callDuration: json["call_duration"],
        callStatus: json["call_status"],
        blockStatus: json["block_status"],
        callDateTime: json["call_date_time"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "caller_id": callerId,
        "full_name": fullName,
        "call_type": callType,
        "call_duration": callDuration,
        "call_status": callStatus,
        "block_status": blockStatus,
        "call_date_time": callDateTime,
      };
}
