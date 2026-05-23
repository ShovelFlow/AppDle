import 'dart:io';

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

  Future<Map<String, dynamic>>? _gameJsonsFuture;

  @override
  void initState() {
    super.initState();
    _gameJsonsFuture = GameRepository.instance.getGameJsons(widget.game);
  }

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

  Text _validValue(String? text, [String? emptyText]) {
    if (text != null && text.isNotEmpty) {
      return Text(text);
    }
    if (emptyText != null) {
      return Text(
        emptyText,
        style: TextStyle(color: Theme.of(context).disabledColor),
      );
    }
    return Text(
      TextManager.get("NO_VALUE"),
      style: TextStyle(color: Theme.of(context).disabledColor),
    );
  }
  TableRow _row(String header, String? value) {
    return TableRow(
      children: [
        Text(
          TextManager.get(header),
          style: TextStyle(color: Theme.of(context).disabledColor),
        ),
        _validValue(value)
      ]
    );
  }
  List<TableRow> _rowKeys(dynamic gameJsons) {
    List<TableRow> list = [];
    final TextStyle headerTextStyle = TextStyle(
      color: Theme.of(context).disabledColor,
      decoration: TextDecoration.underline,
      fontSize: 16
    );

    list.add(
      TableRow(
        children: [
          Text(
            TextManager.get("INFO_KEYS_NAME_HEADER"),
            style: headerTextStyle,
          ),
          Text(
            TextManager.get("INFO_KEYS_TYPE_HEADER"),
            style: headerTextStyle,
          ),
          Text(
            TextManager.get("INFO_KEYS_DESC_HEADER"),
            style: headerTextStyle,
          ),
        ]
      )
    );
    
    // Validamos que "keys" exista y sea un Mapa
    var keysData = gameJsons["data"]["game"]["keys"];
    if (keysData is Map) {
      // Recorremos el mapa usando .entries (contiene key y value)
      for (var entry in keysData.entries) {
        final keyName = entry.key;
        final keyValue = entry.value;
        list.add(
          TableRow(
            children: [
              Text(keyName.toString()), 
              _validValue(keyValue["type"]?.toString()),
              _validValue(keyValue["description"]?.toString(), "")
            ]
          )
        );
      }
    }
    return list;
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

      body: FutureBuilder<Map<String, dynamic>>(
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

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [

              Text(
                widget.game.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              if (widget.game.bannerImage.isNotEmpty)
                SizedBox(
                  height: 150,
                  child:  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Image.file(
                      File(widget.game.bannerImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              
              const SizedBox(height: 16),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2)
                },
                children: [
                  _row("INFO_AUTHOR", widget.game.author),
                  _row("INFO_VERSION", widget.game.version),
                  _row("INFO_GAME_TYPE", gameJsons["data"]["game"]["type"]),
                  _row("INFO_DESCRIPTION", gameJsons["data"]["description"]),
                ],
              ),

              const SizedBox(height: 16),
              Text(
                TextManager.get("INFO_KEYS_HEADER"),
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1)
                },
                children: _rowKeys(gameJsons)
              )

            ],
          );
        },
      ),
    );
  }
}