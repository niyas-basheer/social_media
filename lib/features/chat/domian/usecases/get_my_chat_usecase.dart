
import 'package:test_server_app/features/chat/domian/entities/chat_entity.dart';
import 'package:test_server_app/features/chat/domian/repository/chat_repository.dart';

class GetMyChatUseCase {

  final ChatRepository repository;

  GetMyChatUseCase({required this.repository});

  Stream<List<ChatEntity>> call(ChatEntity chat)  {
    return repository.getMyChat(chat);
  }
}