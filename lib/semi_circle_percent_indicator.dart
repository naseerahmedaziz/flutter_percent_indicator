import 'package:flutter/material.dart';
import 'dart:math' as math;

class SemiCircleProgressIndicator extends StatefulWidget {
  final double percent;
  final double radius;
  final double lineWidth;
  final Color progressColor;
  final Color backgroundColor;
  final bool animation;
  final int animationDuration;
  final Widget? center;
  final Widget? footer;
  final bool showStartValue;
  final bool showEndValue;
  final String? startValue;
  final String? endValue;
  final TextStyle? valueTextStyle;

  const SemiCircleProgressIndicator({
    Key? key,
    required this.percent,
    required this.radius,
    this.lineWidth = 10.0,
    this.progressColor = Colors.red,
    this.backgroundColor = Colors.grey,
    this.animation = true,
    this.animationDuration = 1000,
    this.center,
    this.footer,
    this.showStartValue = true,
    this.showEndValue = true,
    this.startValue = "",
    this.endValue = "",
    this.valueTextStyle,
  })  : assert(percent >= 0.0 && percent <= 1.0),
        super(key: key);

  @override
  State<SemiCircleProgressIndicator> createState() =>
      _SemiCircleProgressIndicatorState();
}

class _SemiCircleProgressIndicatorState
    extends State<SemiCircleProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _currentPercent = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.animation) {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.animationDuration),
      );
      _animation = Tween<double>(begin: 0.0, end: widget.percent).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      )..addListener(() {
          setState(() {
            _currentPercent = _animation.value;
          });
        });
      _animationController.forward();
    } else {
      _currentPercent = widget.percent;
    }
  }

  @override
  void didUpdateWidget(SemiCircleProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent != widget.percent) {
      if (widget.animation) {
        _animation = Tween<double>(
          begin: oldWidget.percent,
          end: widget.percent,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
        _animationController
          ..reset()
          ..forward();
      } else {
        setState(() {
          _currentPercent = widget.percent;
        });
      }
    }
  }

  @override
  void dispose() {
    if (widget.animation) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final defaultTextStyle = widget.valueTextStyle ??
    //     TextStyle(
    //       fontSize: 14,
    //       color: Colors.black87,
    //       fontWeight: FontWeight.w500,
    //     );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.radius,
          width: widget.radius * 2,
          child: Stack(
            children: [
              CustomPaint(
                size: Size(widget.radius * 2, widget.radius),
                painter: _SemiCirclePainter(
                  percent: _currentPercent,
                  progressColor: widget.progressColor,
                  backgroundColor: widget.backgroundColor,
                  strokeWidth: widget.lineWidth,
                ),
              ),
              if (widget.center != null)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment(0, -0.3),
                    child: widget.center!,
                  ),
                ),
              // if (widget.showStartValue)
              //   Positioned(
              //     bottom: 0,
              //     left: 0,
              //     child: Text(
              //       widget.startValue!,
              //       style: defaultTextStyle,
              //     ),
              //   ),
              // if (widget.showEndValue)
              //   Positioned(
              //     bottom: 0,
              //     right: 0,
              //     child: Text(
              //       widget.endValue!,
              //       style: defaultTextStyle,
              //     ),
              //   ),
            ],
          ),
        ),
        if (widget.footer != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: widget.footer!,
          ),
      ],
    );
  }
}

class _SemiCirclePainter extends CustomPainter {
  final double percent;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _SemiCirclePainter({
    required this.percent,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.height;

    // Paint for the background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Paint for the progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      backgroundPaint,
    );

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * percent,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SemiCirclePainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
