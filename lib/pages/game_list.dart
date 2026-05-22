import 'package:appdle/services/game_repository.dart';
import 'package:appdle/widget/game_banner.dart';
import 'package:flutter/material.dart';

class GameListPage extends StatefulWidget {
  const GameListPage({super.key});

  @override
  State<StatefulWidget> createState() => _GameListPage();
}

class _GameListPage extends State<GameListPage> {

  Color _parseColor(String value) {
    final hex = value.replaceFirst('#', '');
    final normalized = hex.length == 6 ? 'FF$hex' : hex;
    return Color(int.parse(normalized, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ValueListenableBuilder(
        valueListenable: GameRepository.instance.games,
        builder: (context, games, _) {

          if (games.isEmpty) {
            return const Center(
              child: Text("No games installed"),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];

              return GameBanner(
                name: game.name,
                author: game.author,
                bannerPath: game.bannerImage,
                color: _parseColor(game.bannerColor),
                onTap: () {
                  print("Abrir ${game.name}");
                },
              );
            },
          );
        },
      ),
    );
  }
}
