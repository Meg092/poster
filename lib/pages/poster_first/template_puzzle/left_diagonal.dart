import 'package:flutter/material.dart';

class LeftFirstDiagonalContainer extends StatelessWidget {
  final double width;
  final double height;
  final double bottomWidthFactor;
  final Widget child;

  const LeftFirstDiagonalContainer({
    Key? key,
    required this.child,
    this.width = 300,
    this.height = 300,
    this.bottomWidthFactor = 0.1,
  })  : assert(bottomWidthFactor > 0 && bottomWidthFactor <= 1,
  'bottomWidthFactor must be between 0 and 1'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(width, height),
          painter: RightFirstDiagonalPainter(

          ),
        ),
        Container(
          width: width,
          height: height,
          child: ClipPath(
            clipper: LeftFirstDiagonalClipper(

            ),
            child: Container(
              width: width,
              height: height,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class RightFirstDiagonalContainer extends StatelessWidget {
  final double width;
  final double height;
  final double topWidthFactor;
  final Widget child;

  const RightFirstDiagonalContainer({
    Key? key,
    required this.child,
    this.width = 300,
    this.height = 300,
    this.topWidthFactor = 0.1,
  })  : assert(topWidthFactor > 0 && topWidthFactor <= 1,
  'topWidthFactor must be between 0 and 1'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(width, height),
          painter: RightFirstDiagonalPainter(

          ),
        ),
        Container(
          width: width,
          height: height,
          child: ClipPath(
            clipper: RightFirstDiagonalClipper(

            ),
            child: Container(
              width: width,
              height: height,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class RightFirstDiagonalClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    final path = Path();

    double height = size.height;

    Offset topLeft = const Offset(0, 0);
    Offset topRight = Offset(size.width, 0);
    Offset bottomRight = Offset(size.width, height);

    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(topRight.dx, topRight.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant RightFirstDiagonalClipper oldClipper) {
    return false;
  }
}

class RightFirstDiagonalPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    double height = size.height;

    Offset topLeft = const Offset(0, 0);
    Offset topRight = Offset(size.width, 0);
    Offset bottomRight = Offset(size.width, height);

    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(topRight.dx, topRight.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class LeftFirstDiagonalClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    final path = Path();

    Offset topLeft = const Offset(0, 0);
    Offset bottomRight = Offset(size.width, size.height);
    Offset bottomLeft = Offset(0, size.height);

    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant LeftFirstDiagonalClipper oldClipper) {
    return false;
  }
}

class LeftTrapezoidPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    Offset topLeft = const Offset(0, 0);
    Offset bottomRight = Offset(size.width, size.height);
    Offset bottomLeft = Offset(0, size.height);

    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}