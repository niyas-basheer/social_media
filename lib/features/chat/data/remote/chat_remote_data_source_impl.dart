import 'package:http/http.dart' as http;
import 'package:test_server_app/features/app/const/message_type_const.dart';
import 'package:test_server_app/features/chat/data/models/chat_model.dart';
import 'package:test_server_app/features/chat/data/models/message_model.dart';
import 'package:test_server_app/features/chat/data/remote/chat_remote_data_source.dart';
import 'package:test_server_app/features/chat/domian/entities/chat_entity.dart';
import 'package:test_server_app/features/chat/domian/entities/message_entity.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final String serverUrl;

  ChatRemoteDataSourceImpl({required this.serverUrl});

  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) async {
    String messageid = await sendMessageBasedOnType(message);
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
        participants: [chat.senderUid!, chat.recipientUid!],
        messages: [messageid]));
  }

  Future<void> addToChat(ChatEntity chat) async {
    final endpoint = Uri.parse("$serverUrl/api/chat/");

    try {
      final myChat = await getMyChat(chat.senderUid).first;
      final otherchat = await getMyChat(chat.recipientUid).first;
      
      final chatListOther = otherchat.firstWhere(
        (existingChat) => existingChat.senderUid == chat.recipientUid,
        orElse: () => createChatModel(
          
         recipientProfile: chat.senderProfile,
        senderProfile : chat.recipientProfile, 
          senderUid: chat.recipientUid ?? '', 
          recipientUid:  chat.senderUid ?? '',
           recipientName: chat.senderName ?? '',
            senderName: chat.recipientName ?? '',
        ),
      );

      final chatListUser = myChat.firstWhere(
        (existingChat) =>existingChat.senderUid == chat.senderUid,
        orElse: () => createChatModel(
          senderProfile : chat.senderProfile,
        recipientProfile : chat.recipientProfile, 
          recipientUid: chat.recipientUid ?? '', 
          senderUid:  chat.senderUid ?? '',
          senderName : chat.senderName ?? '',
            recipientName: chat.recipientName ?? '',
        ),
      );
     

      final existingMessageIds = chatListUser.messages??[];
      
      final messages = {...?chat.messages, ...existingMessageIds}.toList();
      Map<String, dynamic> createChatData(
          String senderUid,
          String recipientUid,
          String senderName,
          String recipientName,
          String? senderProfile,
          String? recipientProfile,
          List<String> messages) {
        return {
          "type": 'individual',
          "participants": [senderUid],
          "senderUid": senderUid,
          "recipientUid": recipientUid,
          "senderProfile": senderProfile,
          "recipientProfile": recipientProfile,
          "recentTextMessage": chat.recentTextMessage,
          "recipientName": recipientName,
          "senderName": senderName,
          "totalUnReadMessages": chat.totalUnReadMessages,
          "messages": messages,
        };
      }

      final chatDataUser = createChatData(
        chat.senderUid ?? '',
        chat.recipientUid ?? '',
        chat.senderName ?? '',
        chat.recipientName ?? '',
        chat.senderProfile,
        chat.recipientProfile,
        messages,
      );

      final chatDataOther = createChatData(
        chat.recipientUid ?? '',
        chat.senderUid ?? '',
        chat.recipientName ?? '',
        chat.senderName ?? '',
        chat.recipientProfile,
        chat.senderProfile,
        messages,
      );

      Future<void> sendRequest(

          Uri url, Map<String, dynamic> data, String method) async {
        final response = await (method == 'POST'
            ? http.post(url, body: json.encode(data), headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
              })
            : http.put(url, body: json.encode(data), headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
              }));

        if (response.statusCode != (method == 'POST' ? 201 : 200)) {
          throw Exception("Failed to $method chat: ${response.body}");
        }
      }

      if (chatListUser.id == '') {
        await Future.wait([
          sendRequest(endpoint, chatDataUser, 'POST'),
          sendRequest(endpoint, chatDataOther, 'POST'),
        ]);
      } else {
        // Update chat
        final updateUrlUser =
            Uri.parse("$serverUrl/api/chat/${chatListUser.id}");
        final updateUrlOther =
            Uri.parse("$serverUrl/api/chat/${chatListOther.id}");

        await Future.wait([
          sendRequest(updateUrlUser, chatDataUser, 'PUT'),
          sendRequest(updateUrlOther, chatDataOther, 'PUT'),
        ]);
      }
    } catch (e) {
      print("Error in addToChat: $e");
    }
  }

  Future<String> sendMessageBasedOnType(MessageEntity message) async {
    final endpoint = Uri.parse("$serverUrl/api/messages/");
    final messageId = const Uuid().v1();

    final messageData = {
      "senderUid": message.senderUid,
      "recipientUid": message.recipientUid,
      "senderName": message.senderName,
      "recipientName": message.recipientName,
      "messageType": message.messageType,
      "message": message.message,
      "messageId": messageId,
      "repliedTo": message.repliedTo,
      "repliedMessage": message.repliedMessage,
      "isSeen": message.isSeen,
      "repliedMessageType": message.repliedMessageType,
    };

    try {
      final response = await http.post(endpoint,
          body: json.encode(messageData),
          headers: {"Content-Type": "application/json"});
      Map<String, dynamic> parsedJson = jsonDecode(response.body);
      String id = parsedJson['_id'];

      if (response.statusCode != 201) {
        throw Exception("Failed to send message: ${response.body}");
      }

      return id;
    } catch (e) {
      return "";
    }
  }

  @override
  Future<void> deleteChat(ChatEntity chat) async {
    final endpoint = Uri.parse("$serverUrl/api/chat/delete/${chat.id}");

    try {
      final response = await http.delete(endpoint);
      if (response.statusCode != 200) {
        throw Exception("Failed to delete chat: ${response.body}");
      }
    } catch (e) {}
  }

  @override
  Future<void> deleteMessage(MessageEntity message) async {
    final endpoint =
        Uri.parse("$serverUrl/api/message/delete/${message.messageId}");

    try {
      final response = await http.delete(endpoint);
      if (response.statusCode != 200) {
        throw Exception("Failed to delete message: ${response.body}");
      }
    } catch (e) {}
  }

  @override
  Stream<List<MessageModel>> getMessages(MessageEntity message) async* {
    try {
      final myChat = await getMyChat(message.senderUid).first;
      final chatList = myChat
          .firstWhere((chat) => chat.recipientUid == message.recipientUid);

      if (chatList.senderUid == null) {
        yield [];
        return;
      }

      final endpoint = Uri.parse("$serverUrl/api/messages/${chatList.id}");
      final response = await http.get(endpoint);

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body) as List;
        final listMessage = jsonMap
            .map((e) => MessageModel.fromJson(e))
            .toList()
            .reversed
            .toList();
        yield listMessage;
      } else {
        throw Exception("Failed to fetch messages: ${response.body}");
      }
    } catch (e) {
      yield [];
    }
  }

  @override
  Stream<List<ChatEntity>> getMyChat(String? uid) async* {
    final endpoint = Uri.parse("$serverUrl/api/chat/$uid");

    try {
      final response = await http.get(endpoint);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;

        yield data.map((e) => ChatModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to fetch chat list: ${response.body}");
      }
    } catch (e) {}
  }

  @override
  Future<void> seenMessageUpdate(MessageEntity message) async {
    final endpoint = Uri.parse("$serverUrl/api/messages/seen");

    final messageData = {"messageId": message.uid, "isSeen": true};

    try {
      final response = await http.put(endpoint,
          body: json.encode(messageData),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode != 200) {
        throw Exception("Failed to update seen status: ${response.body}");
      }
    } catch (e) {}
  }

  ChatModel createChatModel({
  required String senderUid,
  required String recipientUid,
  required String senderName,
  required String recipientName,
  String? senderProfile,
  String? recipientProfile,
}) {
  return ChatModel(
    id: '',
    participants: const [],
    senderUid: senderUid,
    recipientUid: recipientUid,
    senderName: senderName,
    recipientName: recipientName,
    recentTextMessage: null,
    createdAt: null,
    senderProfile: senderProfile,
    recipientProfile: recipientProfile,
    totalUnReadMessages: 0,
    groupName: null,
    groupDescription: null,
    groupIcon: null,
    groupAdmins: null,
    messages: const [],
  );
}
}
