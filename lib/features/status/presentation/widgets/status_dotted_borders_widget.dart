import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test_server_app/features/app/theme/style.dart';
import 'package:test_server_app/features/status/domain/entities/status_image_entity.dart';

class StatusDottedBordersWidget extends CustomPainter {
  
  final int numberOfStories;
  final int spaceLength;
  final String? uid;
  final List<StatusImageEntity>? images;
  final bool isMe;
  double startOfArcInDegree = 0;

  StatusDottedBordersWidget({required this.numberOfStories,
    this.spaceLength = 10,
    this.uid,
    this.images,
   required this.isMe });

  
  double inRads(double degree) {
    return (degree * pi) / 180;
  }

  @override
  bool shouldRepaint(StatusDottedBordersWidget oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    if (numberOfStories <= 1) {
      
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        min(size.width / 2, size.height / 2),
        Paint()
          ..color =
          isMe ? greyColor.withOpacity(.5) : images![0].viewers!.contains(
              uid) ? greyColor.withOpacity(.5) : tabColor
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke,
      );
    } else {
   
      double arcLength =
          (360 - (numberOfStories * spaceLength)) / numberOfStories;
      if (arcLength <= 0) {
        arcLength = 360 / spaceLength - 1;
      }

      for (int i = 0; i < numberOfStories; i++) {
       
        canvas.drawArc(
          rect,
          inRads(startOfArcInDegree),
         
          inRads(arcLength),
          false,
          Paint()
            ..color =
            isMe ? greyColor.withOpacity(.5) : images![i].viewers!.contains(
                uid) ? greyColor.withOpacity(.5) : tabColor
            ..strokeWidth = 2.5
            ..style = PaintingStyle.stroke,
        );
        startOfArcInDegree += arcLength + spaceLength;
      }
    }
  }
}
