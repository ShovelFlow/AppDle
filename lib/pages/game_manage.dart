import 'package:flutter/material.dart';

class GameManagePage extends StatefulWidget {
  const GameManagePage({super.key});

  @override
  State<StatefulWidget> createState() => _GameManagePage();
}

class _GameManagePage extends State<GameManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:')
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
