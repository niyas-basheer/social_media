
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  final String? uid;
  final String? chatId;
  final String? senderUid;
  final String? recipientUid;
  final String? senderName;
  final String? recipientName;
  final String? messageType;
  final String? message;
  final DateTime? createdAt;
  final bool? isSeen;
  final String? repliedTo;
  final String? repliedMessage;
  final String? repliedMessageType;
  final String? messageId;

  const MessageModel({
    this.uid,
    this.chatId,
    this.senderUid,
    this.recipientUid,
    this.senderName,
    this.recipientName,
    this.messageType,
    this.message,
    this.createdAt,
    this.isSeen,
    this.repliedTo,
    this.repliedMessage,
    this.repliedMessageType,
    this.messageId,
  });

  // fromJson factory method using json_serializable
  factory MessageModel.fromJson(Map<String, dynamic> json) => 
      _$MessageModelFromJson(json);

  // toJson method using json_serializable
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}