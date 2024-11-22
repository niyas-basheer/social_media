
import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {

  final String? senderUid;
  final String? recipientUid;
  final String? senderName;
  final String? recipientName;
  final String? messageType;
  final String? message;
  final DateTime? createdAt;
  final bool? isSeen;
  final String? fileUrl;
  final String? fileName;
  final String? repliedTo;
  final String? repliedMessage;
  final String? repliedMessageType;
  final String? senderProfile;
  final String? recipientProfile;
  final String? messageId;
  final String? uid;

  const MessageEntity(
      {
        this.senderUid,
        this.recipientUid,
        this.senderName,
        this.recipientName,
        this.messageType,
        this.message,
        this.createdAt,
        this.isSeen,
         this.fileUrl,
    this.fileName,
        this.repliedTo,
        this.repliedMessage,
        this.repliedMessageType,
        this.messageId,
        this.senderProfile,
        this.recipientProfile,
        this.uid
      });



  @override
  List<Object?> get props => [
    senderUid,
    recipientUid,
    senderName,
    recipientName,
    messageType,
    message,
    createdAt,
    isSeen,
    repliedTo,
    repliedMessage,
    repliedMessageType,
    messageId,
    senderProfile,
    recipientProfile,
    uid,
  ];

}