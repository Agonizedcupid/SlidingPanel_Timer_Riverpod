import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:sliding_panel/GlobalProviders.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 2),
    action: SnackBarAction(label: 'dismiss', onPressed: () {}),
    content: Text(text),
    behavior: SnackBarBehavior.floating,
  ));
}

class LinearWidgetDemo extends ConsumerStatefulWidget {
  const LinearWidgetDemo({super.key});

  @override
  ConsumerState<LinearWidgetDemo> createState() => _LinearWidgetDemoState();
}

class _LinearWidgetDemoState extends ConsumerState<LinearWidgetDemo>
    with TickerProviderStateMixin {
  late LinearTimerController timerController;

  @override
  void dispose() {
    //timerController1.dispose();
    super.dispose();
  }

  @override
  void initState() {
    timerController = LinearTimerController(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      timerController.start();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 25, bottom: 5),
        height: 10,
        child: LinearTimer(
          duration: Duration(minutes: ref.watch(timerProvider)),
          color: Colors.black,
          backgroundColor: Colors.grey[200],
          controller: timerController,
          onTimerEnd: () {
            showSnackBar(context, "Timer 1 ended");
          },
        ),
      ),
    );
  }
}