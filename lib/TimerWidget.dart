import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'GlobalProviders.dart';

// class TimerWidget extends ConsumerWidget {
//   const TimerWidget({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final timer = ref.watch(timerProvider);
//
//     final timerNotifier = ref.read(timerProvider.notifier);
//     timerNotifier.startTimer();
//
//     final minutes = (timer / 60).floor();
//     final seconds = timer % 60;
//
//     return Text('$minutes : $seconds');
//   }
// }
