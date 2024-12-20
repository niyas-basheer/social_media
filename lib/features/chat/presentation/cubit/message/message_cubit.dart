import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_server_app/features/chat/data/models/message_model.dart';
import 'package:test_server_app/features/chat/domian/entities/chat_entity.dart';
import 'package:test_server_app/features/chat/domian/entities/message_entity.dart';
import 'package:test_server_app/features/chat/domian/entities/message_reply_entity.dart';
import 'package:test_server_app/features/chat/domian/usecases/delete_message_usecase.dart';
import 'package:test_server_app/features/chat/domian/usecases/get_messages_usecase.dart';
import 'package:test_server_app/features/chat/domian/usecases/seen_message_update_usecase.dart';
import 'package:test_server_app/features/chat/domian/usecases/send_message_usecase.dart';


part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final DeleteMessageUseCase deleteMessageUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SeenMessageUpdateUseCase seenMessageUpdateUseCase;
  MessageCubit({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.deleteMessageUseCase,
    required this.seenMessageUpdateUseCase
  }) : super(MessageInitial());

 Future<void> getMessages({required MessageEntity message}) async {
  try {

    if (message.recipientUid == null) {
      emit(const MessageLoaded(messages: []));
      return;
    }

    emit(MessageLoading());
    final streamResponse = getMessagesUseCase.call(message);
    
    await for (final messages in streamResponse) {
      emit(MessageLoaded(messages: messages));
      
    }
  } on SocketException {
    emit(MessageFailure());
  } catch (e) {
    emit(MessageFailure());
  }
}



  Future<void> deleteMessage({required MessageEntity message}) async {
    try {

      await deleteMessageUseCase.call(message);

    } on SocketException {
      emit(MessageFailure());
    } catch (_) {
      emit(MessageFailure());
    }
  }

  Future<void> sendMessage({required ChatEntity chat, required MessageEntity message}) async {
    try {

      await sendMessageUseCase.call(chat, message);

    } on SocketException {
      emit(MessageFailure());
    } catch (_) {
      emit(MessageFailure());
    }
  }

  Future<void> seenMessage({required MessageEntity message}) async {
    try {

      await seenMessageUpdateUseCase.call( message);

    } on SocketException {
      emit(MessageFailure());
    } catch (_) {
      emit(MessageFailure());
    }
  }

  MessageReplayEntity messageReplay = MessageReplayEntity();

  MessageReplayEntity get getMessageReplay => MessageReplayEntity();

  set setMessageReplay(MessageReplayEntity messageReplay) {
    this.messageReplay = messageReplay;
  }


}
