
import 'package:test_server_app/features/chat/domian/entities/message_entity.dart';
import 'package:test_server_app/features/chat/domian/repository/chat_repository.dart';

class DeleteMessageUseCase {

  final ChatRepository repository;

  DeleteMessageUseCase({required this.repository});

  Future<void> call(MessageEntity message) async {
    return await repository.deleteMessage(message);
  }
}