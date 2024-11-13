
import 'package:equatable/equatable.dart';

class CallEntity extends Equatable {

  final String? callId;
  final String? callerId;
  final String? callerName;
  final String? callerProfileUrl;

  final String? receiverId;
  final String? receiverName;
  final String? receiverProfileUrl;
  final bool? isCallDialed;
  final bool? isMissed;
  final DateTime? createdAt;

  const CallEntity(
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
      });

  @override
  List<Object?> get props => [
    callId,
    callerId,
    callerName,
    callerProfileUrl,
    receiverId,
    receiverName,
    receiverProfileUrl,
    isCallDialed,
    isMissed,
    createdAt,
  ];
Map<String, dynamic> toJson() {
    return {
      'callId': callId,
      'callerId': callerId,
      'callerName': callerName,
      'callerProfileUrl': callerProfileUrl,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverProfileUrl': receiverProfileUrl,
      'isCallDialed': isCallDialed,
      'isMissed': isMissed,
      'createdAt': createdAt,
    };
  }

  // Factory method to create CallEntity from JSON
  factory CallEntity.fromJson(Map<String, dynamic> json) {
    return CallEntity(
      callId: json['callId'],
      callerId: json['callerId'],
      callerName: json['callerName'],
      callerProfileUrl: json['callerProfileUrl'],
      receiverId: json['receiverId'],
      receiverName: json['receiverName'],
      receiverProfileUrl: json['receiverProfileUrl'],
      isCallDialed: json['isCallDialed'],
      isMissed: json['isMissed'],
      createdAt: json['createdAt'] as DateTime?,
    );
  }

}