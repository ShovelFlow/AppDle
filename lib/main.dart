import 'package:appdle/localization/text_manager.dart';
import 'package:appdle/pages/game_list.dart';
import 'package:appdle/services/game_repository.dart';
import 'package:appdle/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SettingsService.init();
  await GameRepository.instance.loadGames();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top,
    ]
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool darkMode;
  late Color primaryColor;
  late Color correctColor;
  late Color wrongColor;
  late Color neutralColor;

  @override
  void initState() {
    super.initState();

    TextManager.changeLanguage(SettingsService.getLanguaje());

    darkMode = SettingsService.getDarkMode();
    primaryColor = SettingsService.getPrimaryColor();
    correctColor = SettingsService.getCorrectColor();
    wrongColor   = SettingsService.getWrongColor();
    neutralColor = SettingsService.getNeutralColor();
  }

  void toggleTheme(bool value) {
    setState(() {
      darkMode = value;
    });
    SettingsService.setDarkMode(value);
  }

  void changePrimary(Color color) {setState(() {primaryColor = color;});SettingsService.setPrimaryColor(color);}
  void changeCorrect(Color color) {setState(() {correctColor = color;});SettingsService.setCorrectColor(color);}
  void changeWrong(Color color)   {setState(() {wrongColor   = color;});SettingsService.setWrongColor(color);}
  void changeNeutral(Color color) {setState(() {neutralColor = color;});SettingsService.setNeutralColor(color);}

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
