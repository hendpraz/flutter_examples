import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DelayingShimmerWidget extends StatefulWidget {
  const DelayingShimmerWidget({
    super.key,
    required this.tickDuration,
    required this.shimmerTicks,
    required this.delayTicks,
    required this.finishTick,
    required this.isStartingWithShimmer,
    required this.child,
  });

  final Duration tickDuration;
  final int shimmerTicks;
  final int delayTicks;
  final int finishTick;
  final bool isStartingWithShimmer;
  final Widget child;

  @override
  State<DelayingShimmerWidget> createState() => _DelayingShimmerWidgetState();
}

class _DelayingShimmerWidgetState extends State<DelayingShimmerWidget> {
  Timer? timer;

  int tick = 0;
  final List<bool> isShimmeringArray = [];

  @override
  void initState() {
    super.initState();

    List<bool> periodArray;

    if (widget.isStartingWithShimmer) {
      periodArray = List.generate(widget.shimmerTicks + widget.delayTicks,
          (index) => index < widget.shimmerTicks);
    } else {
      periodArray = List.generate(widget.shimmerTicks + widget.delayTicks,
          (index) => index >= widget.delayTicks);
    }

    while (isShimmeringArray.length < widget.finishTick) {
      isShimmeringArray.addAll(periodArray);
    }
  }

  @override
  Widget build(BuildContext context) {
    timer ??= Timer.periodic(widget.tickDuration, (t) {
      if (ModalRoute.of(context)!.isCurrent) {
        setState(() {
          tick++;
        });
      }
    });

    if (tick >= widget.finishTick) {
      timer?.cancel();

      return widget.child;
    }

    var isShimmering = isShimmeringArray[tick];

    if (isShimmering) {
      return Stack(
        children: [
          widget.child,
          Shimmer.fromColors(
            baseColor: Colors.transparent,
            highlightColor: Colors.white.withOpacity(0.5),
            period: widget.tickDuration,
            child: widget.child,
          ),
        ],
      );
    } else {
      return widget.child;
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }
}
