import 'package:flutter/material.dart';

class LeftTrapezoidContainer extends StatelessWidget {
  final double width;
  final double height;
  final double bottomWidthFactor;
  final Widget child;

  const LeftTrapezoidContainer({
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
          painter: LeftTrapezoidPainter(
            bottomWidthFactor: bottomWidthFactor,
          ),
        ),
        Container(
          width: width,
          height: height,
          child: ClipPath(
            clipper: LeftTrapezoidClipper(
              bottomWidthFactor: bottomWidthFactor,
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

class RightTrapezoidContainer extends StatelessWidget {
  final double width;
  final double height;
  final double topWidthFactor;
  final Widget child;

  const RightTrapezoidContainer({
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
          painter: RightTrapezoidPainter(
            topWidthFactor: topWidthFactor,
          ),
        ),
        Container(
          width: width,
          height: height,
          child: ClipPath(
            clipper: RightTrapezoidClipper(
              topWidthFactor: topWidthFactor,
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

class RightTrapezoidClipper extends CustomClipper<Path> {
  final double topWidthFactor;

  RightTrapezoidClipper({this.topWidthFactor = 0.1});

  @override
  Path getClip(Size size) {
    final path = Path();

    double topWidth = size.width * topWidthFactor;
    double bottomWidth = size.width*(1-topWidthFactor);
    double height = size.height;

    Offset topLeft = Offset((size.width - topWidth) , 0);
    Offset topRight = Offset(size.width, 0);
    Offset bottomRight = Offset(size.width, height);
    Offset bottomLeft = Offset(size.width - bottomWidth, height);

    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(topRight.dx, topRight.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant RightTrapezoidClipper oldClipper) {
    return oldClipper.topWidthFactor != topWidthFactor;
  }
}

class RightTrapezoidPainter extends CustomPainter {
  final double topWidthFactor;

  RightTrapezoidPainter({
    this.topWidthFactor = 0.1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    double topWidth = size.width * topWidthFactor;
    double bottomWidth = size.width*(1-topWidthFactor);
    double height = size.height;

    Offset topLeft = Offset((size.width - topWidth) , 0);
    Offset topRight = Offset(size.width, 0);
    Offset bottomRight = Offset(size.width, height);
    Offset bottomLeft = Offset(size.width - bottomWidth, height);

    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(topRight.dx, topRight.dy);
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

class LeftTrapezoidClipper extends CustomClipper<Path> {
  final double bottomWidthFactor;

  LeftTrapezoidClipper({this.bottomWidthFactor = 0.1});

  @override
  Path getClip(Size size) {
    final path = Path();

    double topWidth = size.width;
    double bottomWidth = size.width* bottomWidthFactor;
    double height = size.height;

    Offset topLeft = const Offset( 0, 0);
    Offset topRight = Offset(topWidth, 0);
    Offset bottomRight = Offset(bottomWidth, height);
    Offset bottomLeft = Offset(0, height);

    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(topRight.dx, topRight.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant LeftTrapezoidClipper oldClipper) {
    return oldClipper.bottomWidthFactor != bottomWidthFactor;
  }
}

class LeftTrapezoidPainter extends CustomPainter {

  final double bottomWidthFactor;

  LeftTrapezoidPainter({
    this.bottomWidthFactor = 0.1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    double topWidth = size.width;
    double bottomWidth = size.width* bottomWidthFactor;
    double height = size.height;

    Offset topLeft = const Offset( 0, 0);
    Offset topRight = Offset(topWidth, 0);
    Offset bottomRight = Offset(bottomWidth, height);
    Offset bottomLeft = Offset(0, height);

    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(topRight.dx, topRight.dy);
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