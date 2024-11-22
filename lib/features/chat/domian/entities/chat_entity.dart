
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final List<String> participants; 
  final String type; 
  final String? senderUid; 
  final String? recipientUid; 
  final String? senderName;
  final String? recipientName;
  final String? recentTextMessage;
  final DateTime? createdAt;
  final String? senderProfile;
  final String? recipientProfile;
  final int totalUnReadMessages;
  final String? groupName; 
  final String? groupDescription;
  final String? groupIcon;
  final List<String>? groupAdmins; 
  final List<String>? messages; 

  const ChatEntity({
    required this.participants,
    required this.type,
    this.senderUid,
    this.recipientUid,
    this.senderName,
    this.recipientName,
    this.recentTextMessage,
    this.createdAt,
    this.senderProfile,
    this.recipientProfile,
    this.totalUnReadMessages = 0,
    this.groupName,
    this.groupDescription,
    this.groupIcon,
    this.groupAdmins,
    this.messages, 
  });

 

  @override
  List<Object?> get props => [
    participants,
    type,
    senderUid,
    recipientUid,
    senderName,
    recipientName,
    recentTextMessage,
    createdAt,
    senderProfile,
    recipientProfile,
    totalUnReadMessages,
    groupName,
    groupDescription,
    groupIcon,
    groupAdmins,
    messages,
  ];

  
}
