

import 'package:test_server_app/features/chat/data/models/message_model.dart';
import 'package:test_server_app/features/chat/data/remote/chat_remote_data_source.dart';
import 'package:test_server_app/features/chat/domian/entities/chat_entity.dart';
import 'package:test_server_app/features/chat/domian/entities/message_entity.dart';
import 'package:test_server_app/features/chat/domian/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});
  @override
  Future<void> deleteChat(ChatEntity chat) async => remoteDataSource.deleteChat(chat);

  @override
  Future<void> deleteMessage(MessageEntity message) async => remoteDataSource.deleteMessage(message);
  @override
  Stream<List<MessageModel>> getMessages(MessageEntity message) => remoteDataSource.getMessages(message);

  @override
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat) => remoteDataSource.getMyChat(chat.senderUid);
  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) async => remoteDataSource.sendMessage(chat, message);

  @override
  Future<void> seenMessageUpdate(MessageEntity message) async => remoteDataSource.seenMessageUpdate(message);

}