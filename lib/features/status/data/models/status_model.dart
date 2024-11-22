// ignore_for_file: public_member_api_docs, sort_constructors_first



import 'dart:convert';

import 'package:test_server_app/features/status/domain/entities/status_entity.dart';
import 'package:test_server_app/features/status/domain/entities/status_image_entity.dart';

class StatusModel extends StatusEntity {

  @override
  final String? statusId;
  @override
  final String? imageUrl;
  @override
  final String? uid;
  @override
  final String? username;
  @override
  final String? profileUrl;
  @override
  final DateTime? createdAt;
  @override
  final String? phoneNumber;
  @override
  final String? caption;
  @override
  final List<StatusImageEntity>? stories;

  const StatusModel( 
      {this.statusId,
      this.imageUrl,
      this.uid,
      this.username,
      this.profileUrl,
      this.createdAt,
      this.phoneNumber,
      this.caption,
      this.stories}) : super(
    statusId: statusId,
    imageUrl: imageUrl,
    uid: uid,
    username: username,
    profileUrl: profileUrl,
    createdAt: createdAt,
    phoneNumber: phoneNumber,
    caption: caption,
    stories: stories
  );

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'statusId': statusId,
      'imageUrl': imageUrl,
      'uid': uid,
      'username': username,
      'profileUrl': profileUrl,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'phoneNumber': phoneNumber,
      'caption': caption,
      'stories': stories?.map((x) => x?.toMap()).toList(),
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
  return StatusModel(
    statusId: map['statusId'] as String?,
    imageUrl: map['imageUrl'] as String?,
    uid: map['uid'] as String?,
    username: map['username'] as String?,
    profileUrl: map['profileUrl'] as String?,
    createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int) : null,
    phoneNumber: map['phoneNumber'] as String?,
    caption: map['caption'] as String?,
    stories: map['stories'] != null
        ? List<StatusImageEntity>.from(
            (map['stories'] as List).map<StatusImageEntity?>((x) => StatusImageEntity.fromMap(x as Map<String, dynamic>)),
          )
        : null,
  );
}

  String toJson() => json.encode(toMap());

  factory StatusModel.fromJson(String source) => StatusModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
