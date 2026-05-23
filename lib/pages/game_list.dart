import 'package:appdle/localization/text_manager.dart';
import 'package:appdle/pages/game_manage.dart';
import 'package:appdle/pages/attribute/play_attribute.dart';
import 'package:appdle/pages/settings.dart';
import 'package:appdle/services/app_log.dart';
import 'package:appdle/services/game_repository.dart';
import 'package:appdle/widget/game_banner.dart';
import 'package:flutter/material.dart';

class GameListPage extends StatefulWidget {
  const GameListPage({super.key});

  @override
  State<StatefulWidget> createState() => _GameListPage();
}

class _GameListPage extends State<GameListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("AppDle"),
        actions: [
          IconButton(
            icon: const Icon(Icons.apps),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GameManagePage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: ValueListenableBuilder(
        valueListenable: GameRepository.instance.games,
        builder: (context, games, _) {

          if (games.isEmpty) {
            return Center(
              child: Text(TextManager.get('NO_GAMES_INSTALLED')),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width < 800 ? 1 : 2,
              mainAxisExtent: 150,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];

              return GameBanner(
                game: game,
                onTap: () {
                  AppLog.i("Opening game ${game.id}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayAttributePage(game: game),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
