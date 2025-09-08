import 'package:flutter/material.dart';

class LeftSecondDiagonalContainer extends StatelessWidget {
  final double width;
  final double height;
  final double bottomWidthFactor;
  final Widget child;

  const LeftSecondDiagonalContainer({
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
          painter: LeftSecondDiagonalPainter(

          ),
        ),
        Container(
          width: width,
          height: height,
          child: ClipPath(
            clipper: LeftSecondDiagonalClipper(

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

class RightSecondDiagonalContainer extends StatelessWidget {
  final double width;
  final double height;
  final double topWidthFactor;
  final Widget child;

  const RightSecondDiagonalContainer({
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
          painter: RightSecondDiagonalPainter(

          ),
        ),
        Container(
          width: width,
          height: height,
          child: ClipPath(
            clipper: RightSecondDiagonalClipper(

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

class RightSecondDiagonalClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    final path = Path();

    double height = size.height;

    Offset topLeft = Offset(size.width, 0);
    Offset topRight = Offset(size.width, height);
    Offset bottomRight = Offset(0, height);

    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(topRight.dx, topRight.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant RightSecondDiagonalClipper oldClipper) {
    return false;
  }
}

class RightSecondDiagonalPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    double height = size.height;

    Offset topLeft = Offset(size.width, 0);
    Offset topRight = Offset(size.width, height);
    Offset bottomRight = Offset(0, height);

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

class LeftSecondDiagonalClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    final path = Path();

    Offset topLeft = const Offset(0, 0);
    Offset bottomRight = Offset(size.width, 0);
    Offset bottomLeft = Offset(0, size.height);

    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant LeftSecondDiagonalClipper oldClipper) {
    return false;
  }
}

class LeftSecondDiagonalPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    Offset topLeft = const Offset(0, 0);
    Offset bottomRight = Offset(size.width, 0);
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