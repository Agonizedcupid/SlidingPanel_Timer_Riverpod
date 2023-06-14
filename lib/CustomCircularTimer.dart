import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'GlobalProviders.dart';


class CustomCircularTimer extends ConsumerStatefulWidget {
  final int durationMinutes;
  final TextStyle textStyle;
  final Color ringColor;
  final Color fillColor;
  final double strokeWidth;
  final VoidCallback? onComplete;
  final Function(bool)? onTimerStateChanged; // New callback function

  const CustomCircularTimer({
    Key? key,
    required this.durationMinutes,
    required this.textStyle,
    required this.ringColor,
    required this.fillColor,
    required this.strokeWidth,
    this.onComplete,
    required this.onTimerStateChanged, // Pass the callback function
  }) : super(key: key);

  @override
  _CustomCircularTimerState createState() => _CustomCircularTimerState();
}

class _CustomCircularTimerState extends ConsumerState<CustomCircularTimer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late int _currentDuration;
  late Timer _timer;
  bool _paused = false;
  Duration _elapsedDuration = Duration.zero;
  double _fromWhereToStartAnimation = 0.25;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  @override
  void didUpdateWidget(CustomCircularTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.durationMinutes != widget.durationMinutes) {
      _updateCurrentDuration();
    }
  }

  void _initializeTimer() {
    _updateCurrentDuration();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(minutes: 60), // Always represent a full hour
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
      }
    });

    _animationController.value =
        1 - (widget.durationMinutes / 60); // Calculate the initial position based on the duration

    _startTimer();
  }




  void _updateCurrentDuration() {
    _currentDuration = widget.durationMinutes * 60;
    debugPrint("CHECKING_ANIMATIONS 1: ${_currentDuration.toString()}");
    double fractions = 60 / widget.durationMinutes;
    debugPrint("CHECKING_ANIMATIONS 2: ${fractions.toString()}");
    double totalFractions = 100 / fractions;
    debugPrint("CHECKING_ANIMATIONS 3: ${totalFractions.toString()}");
    _fromWhereToStartAnimation = totalFractions / 100;
    debugPrint("CHECKING_ANIMATIONS 4: ${_fromWhereToStartAnimation.toString()}");
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (_currentDuration - _elapsedDuration.inSeconds > 0) {
          _elapsedDuration = _elapsedDuration + const Duration(seconds: 1);
          _animationController.value =
              1 - (_elapsedDuration.inMinutes.toDouble() / 60); // Update the animation based on elapsed time
        } else {
          t.cancel();
          _animationController.stop(); // Stop the animation
          if (widget.onComplete != null) {
            widget.onComplete!();
          }
        }
      });
    });
  }


  void _pauseTimer() {
    if (!_paused) {
      _paused = true;
      _animationController.stop();
      _timer.cancel();
    }
  }

  void _resumeTimer() {
    if (_paused) {
      _paused = false;
      _startTimer();
    }
  }

  String getFormattedTime() {
    final remainingSeconds = _currentDuration - _elapsedDuration.inSeconds;
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(playPauseProvider)) {
      _resumeTimer();
    } else {
      _pauseTimer();
    }

    debugPrint("CHECKING_ANIMATIONS 5: ${_fromWhereToStartAnimation.toString()}");
    _animationController.value =
        1 - _elapsedDuration.inSeconds.toDouble() / _currentDuration.toDouble();

    return CustomPaint(
      painter: _CircularCountdownTimerPainter(
        animation: _animation,
        textStyle: widget.textStyle,
        ringColor: widget.ringColor,
        fillColor: widget.fillColor,
        strokeWidth: widget.strokeWidth,
        duration: widget.durationMinutes
      ),
      child: Center(
        child: Text(
          getFormattedTime(),
          style: widget.textStyle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }
}

class _CircularCountdownTimerPainter extends CustomPainter {
  final Animation<double> animation;
  final TextStyle textStyle;
  final Color ringColor;
  final Color fillColor;
  final double strokeWidth;
  final int duration;

  _CircularCountdownTimerPainter({
    required this.animation,
    required this.textStyle,
    required this.ringColor,
    required this.fillColor,
    required this.strokeWidth,
    required this.duration
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    double startRadians = - pi / 2;

    double sweepRadians = 2 * pi * animation.value * (duration / 60);

    final ringPaint = Paint()
      ..color = ringColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = fillColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, ringPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startRadians,
      sweepRadians,
      false,
      fillPaint,
    );
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}



