// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';

class StatusImageEntity extends Equatable {

  final String? url;
  final String? type;
  final List<String>? viewers;

  const StatusImageEntity({this.url, this.viewers, this.type});


  factory StatusImageEntity.fromJson(Map<String, dynamic> json) {
    return StatusImageEntity(
        url: json['url'],
        type: json['type'],
        viewers: List.from(json['viewers'])
    );
  }

  static Map<String, dynamic> toJsonStatic(StatusImageEntity statusImageEntity) => {
    "url": statusImageEntity.url,
    "viewers": statusImageEntity.viewers,
    "type": statusImageEntity.type,
  };
  Map<String, dynamic> toJson() => {
    "url": url,
    "viewers": viewers,
    "type": type,
  };

  @override
  List<Object?> get props => [
    url,
    viewers,
    type,
  ];

  

 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'type': type,
      'viewers': viewers,
    };
  }

  factory StatusImageEntity.fromMap(Map<String, dynamic> map) {
    return StatusImageEntity(
      url: map['url'] != null ? map['url'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      viewers: map['viewers'] != null ? List<String>.from((map['viewers'] as List<String>) ): null,
    );
  }


}
