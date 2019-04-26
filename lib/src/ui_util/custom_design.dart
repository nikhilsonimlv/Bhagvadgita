import 'package:flutter/material.dart';

class CustomPaintDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: MaterialApp(
        home: Scaffold(
          body: CustomPaint(
            painter: MyCustomPainter(),
            child: Container(
              height: 300,
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path mainBgPath = Path();
    mainBgPath.addRect(Rect.fromLTRB(0.0, 0.0, size.width, size.height));
    paint.color = Colors.brown;
    canvas.drawPath(mainBgPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
