import 'package:appdle/pages/game_list.dart';
import 'package:appdle/services/game_repository.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GameRepository.instance.loadGames();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkMode = true;
  Color primaryColor = Colors.cyanAccent;

  void toggleTheme(bool value) {
    setState(() {
      darkMode = value;
    });
  }

  void changePrimary(Color color) {
    setState(() {
      primaryColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: darkMode ? Brightness.dark : Brightness.light,

        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness:
              darkMode ? Brightness.dark : Brightness.light,
        ),

        useMaterial3: true,
      ),

      home: const GameListPage(),
    );
  }
}
