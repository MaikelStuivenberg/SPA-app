import 'package:flutter/material.dart';

// class AppBarShape extends OutlinedBorder {
//   @override
//   OutlinedBorder copyWith({BorderSide? side}) => this;

//   @override
//   Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
//     Path path = Path()
//       ..fillType = PathFillType.evenOdd
//       ..addRect(rect)
//       ..addRRect(
//         RRect.fromRectAndCorners(
//           Rect.fromLTWH(rect.left, rect.bottom - 5, rect.width, 5),
//           topLeft: const Radius.circular(16),
//           topRight: const Radius.circular(16),
//         ),
//       );
//     return path;
//   }

//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     return getInnerPath(rect, textDirection: textDirection);
//   }

//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
//     /// create shader linear gradient
//     canvas.drawPath(getInnerPath(rect), Paint()..color = Colors.teal);
//   }

//   @override
//   ShapeBorder scale(double t) => this;
// }

class AppBarShape extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const radius = 16.0;

    final path = Path()
      ..lineTo(0, rect.height + radius)
      ..quadraticBezierTo(0, rect.height, radius, rect.height)
      ..lineTo(rect.width - radius, rect.height)
      ..quadraticBezierTo(
          rect.width, rect.height, rect.width, rect.height + radius)
      ..lineTo(rect.width, 0)
      ..close();

    return path;
  }
}
