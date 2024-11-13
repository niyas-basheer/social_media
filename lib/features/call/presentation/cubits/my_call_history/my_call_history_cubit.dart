import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_server_app/features/call/domain/entities/call_entity.dart';
import 'package:test_server_app/features/call/domain/usecases/get_my_call_history_usecase.dart';

part 'my_call_history_state.dart';

class MyCallHistoryCubit extends Cubit<MyCallHistoryState> {
  final GetMyCallHistoryUseCase getMyCallHistoryUseCase;
  MyCallHistoryCubit({
    required this.getMyCallHistoryUseCase
}) : super(MyCallHistoryInitial());

  Future<void> getMyCallHistory({required String uid}) async {
    emit(MyCallHistoryLoading());
    try {

      final streamResponse = getMyCallHistoryUseCase.call(uid);
      streamResponse.listen((myCallHistory) {
        emit(MyCallHistoryLoaded(myCallHistory: myCallHistory));
      });
    } on SocketException {
      emit(MyCallHistoryFailure());
    } catch(_) {
      emit(MyCallHistoryFailure());
    }
  }
}
