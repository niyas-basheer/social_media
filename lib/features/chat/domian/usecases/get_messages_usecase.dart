
import 'package:test_server_app/features/chat/data/models/message_model.dart';
import 'package:test_server_app/features/chat/domian/entities/message_entity.dart';
import 'package:test_server_app/features/chat/domian/repository/chat_repository.dart';

class GetMessagesUseCase {

  final ChatRepository repository;

  GetMessagesUseCase({required this.repository});

  Stream<List<MessageModel>> call(MessageEntity message)  {
    return repository.getMessages(message);
  }
}