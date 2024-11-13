

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

  factory StatusModel.fromSnapshot(Map<String, dynamic> snap) {

    final stories = snap['stories'] as List;
    List<StatusImageEntity> storiesData =
    stories.map((element) => StatusImageEntity.fromJson(element)).toList();

    return StatusModel(
        stories: storiesData,
        statusId: snap['statusId'],
        username: snap['username'],
        phoneNumber: snap['phoneNumber'],
        createdAt: snap['createdAt'],
        uid: snap['uid'],
        profileUrl: snap['profileUrl'],
        imageUrl: snap['imageUrl'],
        caption: snap['caption']
    );
  }

  Map<String, dynamic> toDocument() => {
    "stories": stories?.map((story) => story.toJson()).toList(),
    "statusId": statusId,
    "username": username,
    "phoneNumber": phoneNumber,
    "createdAt": createdAt,
    "uid": uid,
    "profileUrl": profileUrl,
    "imageUrl": imageUrl,
    "caption": caption,
  };
}