import 'dart:async';

import 'package:flutter/widgets.dart';

class PeriodicWidget extends StatefulWidget {
  const PeriodicWidget({
    super.key,
    required this.childEnabled,
    required this.childDisabled,
    required this.periodicDuration,
    required this.timesEnablingList,
    required this.timesDisablingList,
    required this.finishTime,
  });

  final Widget childEnabled;
  final Widget childDisabled;
  final Duration periodicDuration;

  final List<int> timesEnablingList;
  final List<int> timesDisablingList;
  final int finishTime;

  @override
  State<PeriodicWidget> createState() => _PeriodicWidgetState();
}

class _PeriodicWidgetState extends State<PeriodicWidget> {
  Timer? timer;

  int tick = 0;

  @override
  Widget build(BuildContext context) {
    var enableFlag = false;

    timer ??= Timer.periodic(widget.periodicDuration, (t) {
      if (ModalRoute.of(context)!.isCurrent) {
        setState(() {
          tick++;
        });
      }
    });

    if (tick >= widget.finishTime) {
      enableFlag = false;

      timer?.cancel();
    } else if (widget.timesEnablingList.contains(tick)) {
      enableFlag = true;
    } else if (widget.timesDisablingList.contains(tick)) {
      enableFlag = false;
    }

    if (enableFlag) {
      return widget.childEnabled;
    } else {
      return widget.childDisabled;
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }
}
