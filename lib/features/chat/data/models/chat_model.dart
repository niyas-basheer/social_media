// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:test_server_app/features/chat/domian/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  @override
  final List<String> participants; 
  @override
  final String type;
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
  final int totalUnReadMessages;
  @override
  final String? groupName; 
  @override
  final String? groupDescription;
  @override
  final String? groupIcon;
  @override
  final List<String>? groupAdmins; 
  @override
  final List<String>? messages;

  const ChatModel({
     required this.participants,
    required this.type,
    this.senderUid,
    this.recipientUid,
    this.senderName,
    this.recipientName,
    this.recentTextMessage,
    required this.createdAt,
    this.senderProfile,
    this.recipientProfile,
    this.totalUnReadMessages = 0,
    this.groupName,
    this.groupDescription,
    this.groupIcon,
    this.groupAdmins,
    this.messages,
  }) : super(
    participants:participants,
    type:type,
    senderUid:senderUid,
    recipientUid:recipientUid,
    senderName:senderName,
    recipientName:recipientName,
    recentTextMessage:recentTextMessage,
    createdAt:createdAt,
    senderProfile:senderProfile,
    recipientProfile:recipientProfile,
    totalUnReadMessages :totalUnReadMessages,
    groupName:groupName,
    groupDescription:groupDescription,
    groupIcon:groupIcon,
    groupAdmins:groupAdmins,
    messages:messages,
    
  );

  

  
 factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      participants: json['participants'].cast<String>(),
      type: json['type'],
      senderUid: json['senderUid'],
      recipientUid: json['recipientUid'],
      senderName: json['senderName'],
      recipientName: json['recipientName'],
      recentTextMessage: json['recentTextMessage'],
      createdAt: DateTime.parse(json['createdAt']),
      senderProfile: json['senderProfile'],
      recipientProfile: json['recipientProfile'],
      totalUnReadMessages: json['totalUnReadMessages'],
      groupName: json['groupName'],
      groupDescription: json['groupDescription'],
      groupIcon: json['groupIcon'],
      groupAdmins: json['groupAdmins']?.cast<String>(),
      messages: json['messages']?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'type': type,
      'senderUid': senderUid,
      'recipientUid': recipientUid,
      'senderName': senderName,
      'recipientName': recipientName,
      'recentTextMessage': recentTextMessage,
      'createdAt': createdAt?.toIso8601String(),
      'senderProfile': senderProfile,
      'recipientProfile': recipientProfile,
      'totalUnReadMessages': totalUnReadMessages,
      'groupName': groupName,
      'groupDescription': groupDescription,
      'groupIcon': groupIcon,
      'groupAdmins': groupAdmins,
      'messages': messages,
    };
  }

  
}
