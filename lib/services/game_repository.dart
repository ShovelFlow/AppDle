import 'dart:io';
import 'dart:convert';
import 'package:appdle/services/app_log.dart';
import 'package:appdle/services/game_data.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class GameRepository {
  static final GameRepository instance = GameRepository._internal();

  GameRepository._internal();

  ValueNotifier<List<GameData>> games = ValueNotifier<List<GameData>>([]);

  static Future<Directory> getAppDir() async {
    final dir = await getApplicationDocumentsDirectory();
    return Directory('${dir.path}${Platform.pathSeparator}AppDle');
  }

  bool loaded = false;

  void add (GameData gd) {
    games.value = [...games.value, gd];
    AppLog.d("Added game $gd");
  }

  Future<void> loadGames() async {
    AppLog.i("Loading games");
    final dir = await getAppDir();
    final gamesDir = Directory('${dir.path}${Platform.pathSeparator}games');

    if (!await gamesDir.exists()) {
      games = ValueNotifier<List<GameData>>([]);
      loaded = true;
      return;
    }

    final List<GameData> loadedGames = [];

    for (final folder in gamesDir.listSync()) {
      if (folder is Directory) {
        final dataFile = File('${folder.path}${Platform.pathSeparator}data.json');

        if (await dataFile.exists()) {
          final jsonStr = await dataFile.readAsString();
          final json = jsonDecode(jsonStr);

          loadedGames.add(
            GameData(
              id: json["id"],
              name: json["name"],
              author: json["author"],
              version: json["version"],
              bannerImage: p.join(folder.path, json["id"], p.normalize(json["banner"]["banner_image"])),
              bannerColor: json["banner"]["color"],
            ),
          );
        }
      }
    }

    games = ValueNotifier<List<GameData>>(loadedGames);
    loaded = true;
    AppLog.i("${loadedGames.length} games loaded");
  }
}