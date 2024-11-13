
import 'package:equatable/equatable.dart';
import 'package:test_server_app/features/status/domain/entities/status_image_entity.dart';

class StatusEntity extends Equatable {
  final String? statusId;
  final String? imageUrl;
  final String? uid;
  final String? username;
  final String? profileUrl;
  final DateTime? createdAt;
  final String? phoneNumber;
  final String? caption;
  final List<StatusImageEntity>? stories;

  const StatusEntity(
      {
        this.statusId,
      this.imageUrl,
      this.uid,
      this.username,
      this.profileUrl,
      this.createdAt,
      this.phoneNumber,
      this.caption,
      this.stories
      });

  @override
  List<Object?> get props => [
    statusId,
    imageUrl,
    uid,
    username,
    profileUrl,
    createdAt,
    phoneNumber,
    caption,
    stories
  ];
}