


import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {

  final String? senderUid;
  final String? recipientUid;
  final String? senderName;
  final String? recipientName;
  final String? recentTextMessage;
  final DateTime? createdAt;
  final String? senderProfile;
  final String? recipientProfile;
  final num? totalUnReadMessages;

  const ChatEntity(
      {
        this.senderUid,
        this.recipientUid,
        this.senderName,
        this.recipientName,
        this.recentTextMessage,
        this.createdAt,
        this.senderProfile,
        this.recipientProfile,
        this.totalUnReadMessages
      });


  @override
  List<Object?> get props => [
    senderUid,
    recipientUid,
    senderName,
    recipientName,
    recentTextMessage,
    createdAt,
    senderProfile,
    recipientProfile,
    totalUnReadMessages
  ];


}