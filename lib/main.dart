import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:shimmer_example/periodic_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final containerWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[200] ?? Colors.grey,
          width: 2,
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
      width: 280,
      height: 80,
      child: const Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );

    final stackingShimmer = Stack(
      children: [
        containerWidget,
        Shimmer.fromColors(
          baseColor: Colors.transparent,
          highlightColor: Colors.white.withOpacity(0.5),
          child: containerWidget,
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: PeriodicWidget(
          childEnabled: stackingShimmer,
          childDisabled: containerWidget,
          periodicDuration: const Duration(milliseconds: 1500),
          timesEnablingList: const [0, 3, 6, 9],
          timesDisablingList: const [1, 4, 7],
          finishTime: 10,
        ),
      ),
    );
  }
}
