import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';


final timerProvider = StateNotifierProvider<TimerNotifier, int>((ref) => TimerNotifier());

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier() : super(5);

  startTimer() {
    Timer.periodic(Duration(seconds: 1), (_) {
      if (state > 0) {
        state--;
      }
    });
  }

  // Add this method
  addFiveMinutes() {
    state += 5;
  }

  // And this method
  subtractFiveMinutes() {
    if (state > 5) {
      state -= 5;
    }
  }
}

final playPauseProvider = StateProvider<bool>((ref) => true);


void updateSessionPlayPauseProvider(WidgetRef ref, bool val) {
  ref
      .read(playPauseProvider.notifier)
      .update((_) => val);
}