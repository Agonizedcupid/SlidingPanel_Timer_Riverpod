import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_panel/GlobalProviders.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'CustomCircularTimer.dart';
import 'LinearTimer.dart';
import 'TimerWidget.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerNotifier = ref.read(timerProvider.notifier);
    final playPauseNotifier = ref.read(playPauseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sliding Up Panel Example'),
      ),
      body: SlidingUpPanel(
        panel: const ExpandedWidget(),  // Expanded view
        collapsed: const LinearWidgetDemo(),  // Collapsed view
        body: Center(  // Add this center widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  timerNotifier.addFiveMinutes();
                },
                child: Text('Add 5 Minutes'),
              ),
              ElevatedButton(
                onPressed: () {
                  timerNotifier.subtractFiveMinutes();
                },
                child: Text('Subtract 5 Minutes'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (playPauseNotifier) {
                    updateSessionPlayPauseProvider(ref, false);
                  } else {
                    updateSessionPlayPauseProvider(ref, true);

                  }

                },
                child: ref.watch(playPauseProvider)
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow),
              ),
              CustomCircularTimer(
                durationMinutes: ref.watch(timerProvider) ~/ 60,
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
                ringColor: Colors.grey,
                fillColor: Colors.black,
                strokeWidth: 10.0,
                onTimerStateChanged: (isRunning) {},  // Implement the callback here or pass it from outside
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class ExpandedWidget extends ConsumerStatefulWidget {
  const ExpandedWidget({super.key});

  @override
  ConsumerState<ExpandedWidget> createState() => _ExpandedWidgetState();
}

class _ExpandedWidgetState extends ConsumerState<ExpandedWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 250,
          width: 250,
          child: CustomCircularTimer(
            durationMinutes: ref.watch(timerProvider),
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
            ringColor: Colors.grey,
            fillColor: Colors.black,
            strokeWidth: 10.0,
            onTimerStateChanged: (isExpanded) {},  // Implement the callback here or pass it from outside
          ),
        ),
      ),
    );
  }
}

// class CollapsedWidget extends ConsumerStatefulWidget {
//   const CollapsedWidget({super.key});
//
//   @override
//   ConsumerState<CollapsedWidget> createState() => _CollapsedWidgetState();
// }

// class _CollapsedWidgetState extends ConsumerState<CollapsedWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           height: 100,
//           width: 100,
//           child: Row(
//             children: [
//               CustomCircularTimer(
//                 durationMinutes: ref.watch(timerProvider),
//                 textStyle: TextStyle(
//                   color: Colors.black,
//                   fontSize: 24,
//                 ),
//                 ringColor: Colors.grey,
//                 fillColor: Colors.black,
//                 strokeWidth: 10.0,
//                 onTimerStateChanged: (isCollapsed) {},  // Implement the callback here or pass it from outside
//               ),
//             ],
//           ),
//
//         ),
//       ),
//     );
//   }
// }




