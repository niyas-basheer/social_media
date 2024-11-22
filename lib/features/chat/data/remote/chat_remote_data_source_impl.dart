import 'package:http/http.dart' as http;
import 'package:test_server_app/features/chat/data/models/chat_model.dart';
import 'package:test_server_app/features/chat/data/models/message_model.dart';
import 'package:test_server_app/features/chat/data/remote/chat_remote_data_source.dart';
import 'package:test_server_app/features/chat/domian/entities/chat_entity.dart';
import 'package:test_server_app/features/chat/domian/entities/message_entity.dart';
import 'package:test_server_app/features/user/domain/usecases/user/update_user_usecase.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final String baseUrl;
  final UpdateUserUseCase updateUserUseCase;
  ChatRemoteDataSourceImpl({required this.baseUrl,required this.updateUserUseCase});
   
  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) async {
    await sendMessageBasedOnType(message);

    String recentTextMessage = "";

    switch (message.messageType) {
      case 'photoMessage':
        recentTextMessage = '📷 Photo';
        break;
      case 'videoMessage':
        recentTextMessage = '📸 Video';
        break;
      case 'audioMessage':
        recentTextMessage = '🎵 Audio';
        break;
      case 'gifMessage':
        recentTextMessage = 'GIF';
        break;
      default:
        recentTextMessage = message.message!;
    }

    await addToChat(ChatEntity(
       participants:[chat.recipientUid!,chat.senderUid!] ,
      createdAt: chat.createdAt,
      senderProfile: chat.senderProfile,
      recipientProfile: chat.recipientProfile,
      recentTextMessage: recentTextMessage,
      recipientName: chat.recipientName,
      senderName: chat.senderName,
      recipientUid: chat.recipientUid,
      senderUid: chat.senderUid,
      totalUnReadMessages: chat.totalUnReadMessages,type: chat.type
    ));
  }

  Future<void> addToChat(ChatEntity chat) async {
    final url = Uri.parse('$baseUrl/api/chat/messages');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ChatModel(
        participants:[chat.recipientUid!,chat.senderUid!] ,
        createdAt: chat.createdAt,
        senderProfile: chat.senderProfile,
        recipientProfile: chat.recipientProfile,
        recentTextMessage: chat.recentTextMessage,
        recipientName: chat.recipientName,
        senderName: chat.senderName,
        recipientUid: chat.recipientUid,
        senderUid: chat.senderUid,
        totalUnReadMessages: chat.totalUnReadMessages, type: chat.type,
      ).toJson()),
    );

    if (response.statusCode != 200) {
      print("error occur while adding to chat");
    }
  }

  Future<void> sendMessageBasedOnType(MessageEntity message) async {
    final url = Uri.parse('$baseUrl/api/chat/messages');
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

    if (response.statusCode != 201) {
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
    final url = Uri.parse('$baseUrl/api/chat/messages');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'messageId': message.messageId}),
    );

    if (response.statusCode != 200) {
      print("error occur while deleting message ${response.body}");
    }
  }

  @override
  Stream<List<MessageEntity>> getMessages(MessageEntity message) async* {
    final url = Uri.parse('$baseUrl/api/chat/messages/${message.senderUid}/6737299fff0eb19eca30fe67');
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
    print("this re${chat.recipientUid},this sender${chat.senderUid}");
    final url = Uri.parse('$baseUrl/api/chat/messages/${chat.senderUid}/6737299fff0eb19eca30fe67');
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
    final url = Uri.parse('$baseUrl/api/chat/messages/update');
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
