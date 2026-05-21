import 'package:appdle/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:appdle/pages/game_list.dart';
import 'package:appdle/pages/game_manage.dart';
import 'package:appdle/localization/text_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppDle',
      theme: ThemeData.dark(),
      home: const MainNavigator(),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigator();
}

class _MainNavigator extends State<MainNavigator> {
  int _index = 1;

  final List<Widget> _pages = const [
    GameManagePage(),
    GameListPage(),
    SettingsPage(),
  ];

  void _updateIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
		body: IndexedStack(
			index: _index,
			children: _pages,
		),
		bottomNavigationBar: BottomNavigationBar(
			currentIndex: _index,
			onTap: _updateIndex,
			selectedItemColor: Colors.blue,
			items:  [
				BottomNavigationBarItem(
					icon: const Icon(Icons.add),
					label: TextManager.get('MN_MANAGE'),
				),
				BottomNavigationBarItem(
					icon: const Icon(Icons.play_arrow),
					label: TextManager.get('MN_PLAY'),
				),
				BottomNavigationBarItem(
					icon: const Icon(Icons.settings),
					label: TextManager.get('MN_SETTINGS'),
				),
			]
		),
    );
  }
}
