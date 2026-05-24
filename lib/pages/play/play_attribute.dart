import 'package:appdle/localization/text_manager.dart';
import 'package:appdle/widget/game_play_keyboard.dart';
import 'package:appdle/widget/game_play_table.dart';
import 'package:appdle/services/game_data.dart';
import 'package:appdle/services/play_data.dart';
import 'package:appdle/services/game_repository.dart';
import 'package:flutter/material.dart';

class PlayAttributePage extends StatefulWidget {
  const PlayAttributePage({super.key, required this.game});

  final GameData game;
  
  @override
  State<PlayAttributePage> createState() => _PlayAttributePageState();
}

class _PlayAttributePageState extends State<PlayAttributePage> {

  Future<Map<String, dynamic>>? _gameJsonsFuture;
  final PlayData _playData = PlayData();
  
  @override
  void initState() {
    super.initState();
    _gameJsonsFuture = GameRepository.instance.getGameJsons(widget.game);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(TextManager.get("CONFIRM_POPUP_TITLE")),
                content: Text(TextManager.get("RESTART_PLAY_CONFIRM")),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(TextManager.get("CANCEL")),
                  ),
                  TextButton(
                    onPressed: () {
                      _playData.restartPlay();
                      Navigator.of(context).pop();
                    },
                    child: Text(TextManager.get("RESTART")),
                  ),
                ],
              ),
            )
          ),
        ]
      ),

      body: SafeArea(
        maintainBottomViewPadding: true,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _gameJsonsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(TextManager.get("ERROR_NO_GAME_INFO")));
            }
            final gameJsons = snapshot.data!;
            _playData.fillData(gameJsons);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                Expanded(
                  child: GamePlayTable(playData: _playData),
                ),
                GamePlayKeyboard(playData: _playData)
              ],
            );
          }
        ),
      ),
    );
  }
}