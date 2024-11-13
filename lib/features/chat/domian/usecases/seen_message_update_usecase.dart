
import 'package:test_server_app/features/chat/domian/entities/message_entity.dart';
import 'package:test_server_app/features/chat/domian/repository/chat_repository.dart';

class SeenMessageUpdateUseCase {

  final ChatRepository repository;

  SeenMessageUpdateUseCase({required this.repository});

  Future<void> call(MessageEntity message) async {
    return await repository.seenMessageUpdate(message);
  }
}