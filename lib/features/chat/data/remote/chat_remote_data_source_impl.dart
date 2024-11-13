import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:test_server_app/features/app/const/message_type_const.dart';
import 'package:test_server_app/features/chat/data/models/chat_model.dart';
import 'package:test_server_app/features/chat/data/models/message_model.dart';
import 'package:test_server_app/features/chat/data/remote/chat_remote_data_source.dart';
import 'package:test_server_app/features/chat/domian/entities/chat_entity.dart';
import 'package:test_server_app/features/chat/domian/entities/message_entity.dart';
import 'package:uuid/uuid.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final String baseUrl;

  ChatRemoteDataSourceImpl({required this.baseUrl});

  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) async {
    await sendMessageBasedOnType(message);

    String recentTextMessage = "";

    switch (message.messageType) {
      case MessageTypeConst.photoMessage:
        recentTextMessage = '📷 Photo';
        break;
      case MessageTypeConst.videoMessage:
        recentTextMessage = '📸 Video';
        break;
      case MessageTypeConst.audioMessage:
        recentTextMessage = '🎵 Audio';
        break;
      case MessageTypeConst.gifMessage:
        recentTextMessage = 'GIF';
        break;
      default:
        recentTextMessage = message.message!;
    }

    await addToChat(ChatEntity(
      createdAt: chat.createdAt,
      senderProfile: chat.senderProfile,
      recipientProfile: chat.recipientProfile,
      recentTextMessage: recentTextMessage,
      recipientName: chat.recipientName,
      senderName: chat.senderName,
      recipientUid: chat.recipientUid,
      senderUid: chat.senderUid,
      totalUnReadMessages: chat.totalUnReadMessages,
    ));
  }

  Future<void> addToChat(ChatEntity chat) async {
    final url = Uri.parse('$baseUrl/api/chat/add');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ChatModel(
        createdAt: chat.createdAt,
        senderProfile: chat.senderProfile,
        recipientProfile: chat.recipientProfile,
        recentTextMessage: chat.recentTextMessage,
        recipientName: chat.recipientName,
        senderName: chat.senderName,
        recipientUid: chat.recipientUid,
        senderUid: chat.senderUid,
        totalUnReadMessages: chat.totalUnReadMessages,
      ).toDocument()),
    );

    if (response.statusCode != 200) {
      print("error occur while adding to chat");
    }
  }

  Future<void> sendMessageBasedOnType(MessageEntity message) async {
    final url = Uri.parse('$baseUrl/api/message/send');
    String messageId = const Uuid().v1();

    final newMessage = MessageModel(
      senderUid: message.senderUid,
      recipientUid: message.recipientUid,
      senderName: message.senderName,
      recipientName: message.recipientName,
      createdAt: message.createdAt,
      repliedTo: message.repliedTo,
      repliedMessage: message.repliedMessage,
      isSeen: message.isSeen,
      messageType: message.messageType,
      message: message.message,
      messageId: messageId,
      repliedMessageType: message.repliedMessageType,
    ).toDocument();

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newMessage),
    );

    if (response.statusCode != 200) {
      print("error occur while sending message");
    }
  }

  @override
  Future<void> deleteChat(ChatEntity chat) async {
    final url = Uri.parse('$baseUrl/api/chat/delete');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'senderUid': chat.senderUid, 'recipientUid': chat.recipientUid}),
    );

    if (response.statusCode != 200) {
      print("error occur while deleting chat conversation ${response.body}");
    }
  }

  @override
  Future<void> deleteMessage(MessageEntity message) async {
    final url = Uri.parse('$baseUrl/api/message/delete');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'messageId': message.messageId, 'senderUid': message.senderUid, 'recipientUid': message.recipientUid}),
    );

    if (response.statusCode != 200) {
      print("error occur while deleting message ${response.body}");
    }
  }

  @override
  Stream<List<MessageEntity>> getMessages(MessageEntity message) async* {
    final url = Uri.parse('$baseUrl/api/message/get/${message.senderUid}/${message.recipientUid}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> messagesJson = jsonDecode(response.body);
      final messages = messagesJson.map((json) => MessageModel.fromJson(json)).toList();
      yield messages;
    } else {
      throw Exception('Failed to load messages');
    }
  }

  @override
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat) async* {
    final url = Uri.parse('$baseUrl/api/chat/get/${chat.senderUid}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> chatsJson = jsonDecode(response.body);
      final chats = chatsJson.map((json) => ChatModel.fromJson(json)).toList();
      yield chats;
    } else {
      throw Exception('Failed to load chats');
    }
  }

  @override
  Future<void> seenMessageUpdate(MessageEntity message) async {
    final url = Uri.parse('$baseUrl/api/message/update');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'messageId': message.messageId, 'isSeen': true}),
    );

    if (response.statusCode != 200) {
      print("error occur while updating message status ${response.body}");
    }
  }
}
