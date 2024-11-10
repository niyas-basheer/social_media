import 'dart:io';
import 'dart:convert'; // For base64 encoding

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_server_app/features/app/user/data/models/user_model.dart';
import 'package:test_server_app/features/app/user/domain/usecases/credential/sign_in_with_phone_number_usecase.dart';
import 'package:test_server_app/features/app/user/domain/usecases/credential/verify_phone_number_usecsae.dart';
import 'package:test_server_app/features/app/user/domain/usecases/user/create_user_usecase.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInWithPhoneNumberUseCase signInWithPhoneNumberUseCase;
  final VerifyPhoneNumberUseCase verifyPhoneNumberUseCase;
  final CreateUserUseCase createUserUseCase;

  CredentialCubit({
    required this.signInWithPhoneNumberUseCase,
    required this.verifyPhoneNumberUseCase,
    required this.createUserUseCase,
  }) : super(CredentialInitial());

  // Method to verify phone number
  Future<void> submitVerifyPhoneNumber({required String phoneNumber}) async {
    try {
      await verifyPhoneNumberUseCase.call(phoneNumber);
      emit(CredentialPhoneAuthSmsCodeReceived());
    } on SocketException catch (_) {
      emit(CredentialPhoneAuthSmsCodeReceived());
    } catch (_) {
      print("Error in submitVerifyPhoneNumber: $_");
      emit(CredentialPhoneAuthSmsCodeReceived());
    }
  }

  // Method to submit SMS code
  Future<void> submitSmsCode({required String smsCode}) async {
    try {
      await signInWithPhoneNumberUseCase.call(smsCode);
      emit(CredentialPhoneAuthProfileInfo());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  // Method to submit profile info (username and image)
  Future<void> submitProfileInfo({
    required String username,
    required String phoneNumber,
    File? profileImage, required UserModel user, // Optional image
  }) async {
    try {
      // If an image is selected, convert it to Base64
      String? base64Image;
      if (profileImage != null) {
        base64Image = base64Encode(profileImage.readAsBytesSync());
      }

      // Create a UserModel instance with the data
      final user = UserModel(
        username: username,
        phoneNumber: phoneNumber,
        profileUrl: base64Image, // Optional Base64 image
      );

      // Call the create user use case
      await createUserUseCase.call(user);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      print("Error in submitProfileInfo: $_");
      emit(CredentialFailure());
    }
  }
}
