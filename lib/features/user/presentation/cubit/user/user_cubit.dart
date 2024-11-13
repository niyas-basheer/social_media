import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_server_app/features/user/data/models/user_model.dart';
import 'package:test_server_app/features/user/domain/entities/user_entity.dart';
import 'package:test_server_app/features/user/domain/usecases/user/get_all_users_usecase.dart';
import 'package:test_server_app/features/user/domain/usecases/user/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUseCase updateUserUseCase;
  final GetAllUsersUseCase getAllUsersUseCase;
  UserCubit({
    required this.updateUserUseCase,
    required this.getAllUsersUseCase
}) : super(UserInitial());

  Future<void> getAllUsers() async {
    emit(UserLoading());
    final streamResponse = getAllUsersUseCase.call();
    streamResponse.listen((users) {
      emit(UserLoaded(users: users));
    });
  }

  Future<void> updateUser({required UserModel user}) async {
    try {
      await updateUserUseCase.call(user);
    } catch (e) {
      emit(UserFailure());
    }
  }
}
