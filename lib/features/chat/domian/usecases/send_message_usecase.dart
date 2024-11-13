
import 'package:test_server_app/features/chat/domian/entities/chat_entity.dart';
import 'package:test_server_app/features/chat/domian/entities/message_entity.dart';
import 'package:test_server_app/features/chat/domian/repository/chat_repository.dart';

class SendMessageUseCase {

  final ChatRepository repository;

  SendMessageUseCase({required this.repository});

  Future<void> call(ChatEntity chat, MessageEntity message) async {
    return await repository.sendMessage(chat, message);
  }
}