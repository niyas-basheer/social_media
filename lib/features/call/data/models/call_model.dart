


import 'package:test_server_app/features/call/domain/entities/call_entity.dart';

class CallModel extends CallEntity {

  @override
  final String? callId;
  @override
  final String? callerId;
  @override
  final String? callerName;
  @override
  final String? callerProfileUrl;

  @override
  final String? receiverId;
  @override
  final String? receiverName;
  @override
  final String? receiverProfileUrl;
  @override
  final bool? isCallDialed;
  @override
  final bool? isMissed;
  @override
  final DateTime? createdAt;

  const CallModel(
      {
        this.callId,
        this.callerId,
        this.callerName,
        this.callerProfileUrl,
        this.receiverId,
        this.receiverName,
        this.receiverProfileUrl,
        this.isCallDialed,
        this.isMissed,
        this.createdAt,
      }) : super(
    callerId: callerId,
    callerName: callerName,
    callerProfileUrl: callerProfileUrl,
    callId: callId,
    isCallDialed: isCallDialed,
    receiverId: receiverId,
    receiverName: receiverName,
    receiverProfileUrl: receiverProfileUrl,
    isMissed: isMissed,
    createdAt: createdAt,
  );

  factory CallModel.fromJson(Map<String, dynamic> json) {


    return CallModel(
      receiverProfileUrl: json['receiverProfileUrl'],
      receiverName: json['receiverName'],
      receiverId: json['receiverId'],
      isCallDialed: json['isCallDialed'],
      callId: json['callId'],
      callerProfileUrl: json['callerProfileUrl'],
      callerName: json['callerName'],
      callerId: json['callerId'],
      isMissed: json['isMissed'],
      createdAt: json['createdAt'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    "receiverProfileUrl": receiverProfileUrl,
    "receiverName": receiverName,
    "receiverId": receiverId,
    "isCallDialed": isCallDialed,
    "callId": callId,
    "callerProfileUrl": callerProfileUrl,
    "callerName": callerName,
    "callerId": callerId,
    "isMissed": isMissed,
    "createdAt": createdAt,
  };
}