import 'package:appdle/localization/text_manager.dart';
import 'package:appdle/services/game_data.dart';
import 'package:appdle/services/game_repository.dart';
import 'package:appdle/services/import_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class GameManagePage extends StatefulWidget {
  const GameManagePage({super.key});

  @override
  State<StatefulWidget> createState() => _GameManagePage();
}

class _GameManagePage extends State<GameManagePage> {

  Future<void> _importGame() async {
    try {
      final json = await ImportService.importGame();
      final dir = await GameRepository.getAppDir();

      if (json != null && mounted) {
        GameRepository.instance.add(
          GameData(
              id: json["id"],
              name: json["name"],
              author: json["author"],
              version: json["version"],
              bannerImage: p.join(dir.path, 'games', p.normalize(json["banner"]["banner_image"])),
              bannerColor: json["banner"]["color"],
          )
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
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('DWASDA')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _importGame,
        child: const Icon(Icons.add),
      ),
    );
  }
}
