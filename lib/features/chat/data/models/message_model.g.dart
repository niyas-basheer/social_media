// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      uid: json['_id'] as String?,
      chatId: json['chatId'] as String?,
      senderUid: json['senderUid'] as String?,
      recipientUid: json['recipientUid'] as String?,
      senderName: json['senderName'] as String?,
      recipientName: json['recipientName'] as String?,
      messageType: json['messageType'] as String?,
      message: json['message'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt']).toLocal(),
      isSeen: json['isSeen'] as bool?,
      repliedTo: json['repliedTo'] as String?,
      repliedMessage: json['repliedMessage'] as String?,
      repliedMessageType: json['repliedMessageType'] as String?,
      messageId: json['messageId'] as String?,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      '_id': instance.uid,
      'chatId': instance.chatId,
      'senderUid': instance.senderUid,
      'recipientUid': instance.recipientUid,
      'senderName': instance.senderName,
      'recipientName': instance.recipientName,
      'messageType': instance.messageType,
      'message': instance.message,
      'createdAt': instance.createdAt?.toIso8601String(),
      'isSeen': instance.isSeen,
      'repliedTo': instance.repliedTo,
      'repliedMessage': instance.repliedMessage,
      'repliedMessageType': instance.repliedMessageType,
      'messageId': instance.messageId,
    };
