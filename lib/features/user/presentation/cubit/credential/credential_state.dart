// credential_state.dart

abstract class CredentialState {}

class CredentialInitial extends CredentialState {}

class CredentialLoading extends CredentialState {}

class CredentialSuccess extends CredentialState {
  final String message;
  CredentialSuccess(this.message);
}

class CredentialFailure extends CredentialState {
  final String error;
  CredentialFailure(this.error);
}
