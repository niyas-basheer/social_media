import 'package:test_server_app/features/app/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  @override
  final String? username;
  @override
  final String? email;
  @override
  final String? phoneNumber;
  @override
  final bool? isOnline;
  @override
  final String? uid;
  @override
  final String? status;
  @override
  final String? profileUrl;

  const UserModel({
    this.username,
    this.email,
    this.phoneNumber,
    this.isOnline,
    this.uid,
    this.status,
    this.profileUrl,
  }) : super(
    username: username,
    email: email,
    uid: uid,
    profileUrl: profileUrl,
    phoneNumber: phoneNumber,
    isOnline: isOnline,
    status: status
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      isOnline: json['isOnline'],
      uid: json['uid'],
      status: json['status'],
      profileUrl: json['profileUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'phoneNumber': phoneNumber,
    'isOnline': isOnline,
    'uid': uid,
    'status': status,
    'profileUrl': profileUrl,
  };

  @override
  String toString() {
    return 'UserModel{'
        'username: $username, '
        'email: $email, '
        'phoneNumber: $phoneNumber, '
        'isOnline: $isOnline, '
        'uid: $uid, '
        'status: $status, '
        'profileUrl: $profileUrl'
        '}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          email == other.email &&
          phoneNumber == other.phoneNumber &&
          isOnline == other.isOnline &&
          uid == other.uid &&
          status == other.status &&
          profileUrl == other.profileUrl;

  @override
  int get hashCode =>
      username.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      isOnline.hashCode ^
      uid.hashCode ^
      status.hashCode ^
      profileUrl.hashCode;
}