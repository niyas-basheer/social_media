


import 'package:test_server_app/features/chat/domian/entities/chat_entity.dart';

class ChatModel extends ChatEntity {

  @override
  final String? senderUid;
  @override
  final String? recipientUid;
  @override
  final String? senderName;
  @override
  final String? recipientName;
  @override
  final String? recentTextMessage;
  @override
  final DateTime? createdAt;
  @override
  final String? senderProfile;
  @override
  final String? recipientProfile;
  @override
  final num? totalUnReadMessages;

  const ChatModel(
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
      }) : super(
      senderUid: senderUid,
      recipientUid: recipientUid,
      senderName: senderName,
      recipientName: recipientName,
      senderProfile: senderProfile,
      recipientProfile: recipientProfile,
      recentTextMessage: recentTextMessage,
      createdAt: createdAt,
      totalUnReadMessages: totalUnReadMessages
  );

  factory ChatModel.fromJson(Map<String, dynamic> snap) {

    return ChatModel(
      recentTextMessage: snap['recentTextMessage'],
      recipientName: snap['recipientName'],
      totalUnReadMessages: snap['totalUnReadMessages'],
      recipientUid: snap['recipientUid'],
      senderName: snap['senderName'],
      senderUid: snap['senderUid'],
      senderProfile: snap['senderProfile'],
      recipientProfile: snap['recipientProfile'],
      createdAt: snap['createdAt'],
    );
  }

  Map<String, dynamic> toDocument() => {
    "recentTextMessage": recentTextMessage,
    "recipientName": recipientName,
    "totalUnReadMessages": totalUnReadMessages,
    "recipientUid": recipientUid,
    "senderName": senderName,
    "senderUid": senderUid,
    "senderProfile": senderProfile,
    "recipientProfile": recipientProfile,
    "createdAt": createdAt,
  };
}