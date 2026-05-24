import 'package:appdle/localization/text_manager.dart';
import 'package:appdle/pages/game_info.dart';
import 'package:appdle/services/app_log.dart';
import 'package:appdle/services/game_data.dart';
import 'package:appdle/services/game_repository.dart';
import 'package:appdle/services/import_service.dart';
import 'package:appdle/widget/game_banner.dart';
import 'package:flutter/material.dart';

class GameManagePage extends StatefulWidget {
  const GameManagePage({super.key});

  @override
  State<StatefulWidget> createState() => _GameManagePage();
}

class _GameManagePage extends State<GameManagePage> {

  Future<void> _importGame() async {
    try {
      final json = await ImportService.importGame();

      if (json != null && mounted) {
        GameRepository.instance.add(
          GameData.generate(json)
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${TextManager.get('IMPORTED_GAME')}: ${json['name']}",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(TextManager.get('ERROR')),
          content: Text(
            "${TextManager.get('IMPORTED_GAME_ERROR')}.\n\n$e",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(TextManager.get('ACCEPT')),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextManager.get("MN_MANAGE")),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _importGame,
          ),
        ]
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
                  AppLog.i("Manage game ${game.id}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GameInfoPage(game: game),
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
