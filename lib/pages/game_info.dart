import 'package:appdle/localization/text_manager.dart';
import 'package:appdle/services/game_data.dart';
import 'package:appdle/services/game_repository.dart';
import 'package:flutter/material.dart';

class GameInfoPage extends StatefulWidget {

  const GameInfoPage({super.key, required this.game});

  final GameData game;

  @override
  State<StatefulWidget> createState() => _GameInfoPage();
}

class _GameInfoPage extends State<GameInfoPage> {

  void _deleteGame() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(TextManager.get("CONFIRM_POPUP_TITLE")),
          content: Text(TextManager.get("DELETE_GAME_CONFIRM")),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(TextManager.get("CANCEL")),
            ),
            TextButton(
              onPressed: () {
                GameRepository.instance.remove(widget.game);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(TextManager.get("DELETE")),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(TextManager.get("GAME_INFO")),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteGame
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [

          // if (widget.game.bannerImage.isNotEmpty)
          //   Image.file(
          //     File(widget.game.bannerImage),
          //     fit: BoxFit.cover,
          //   ),
          
          Text(
            widget.game.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2)
            },
            children: [
              TableRow(
                children: [
                  Text(TextManager.get("INFO_AUTHOR")),
                  Text(widget.game.author)
                ]
              ),
              TableRow(
                children: [
                  Text(TextManager.get("INFO_VERSION")),
                  Text(widget.game.version)
                ]
              )
            ],
          )

        ],
      ),
    );
  }
}