import 'dart:io';
import 'dart:convert';
import 'package:appdle/services/app_log.dart';
import 'package:appdle/services/game_data.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

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
    final gameList = games.value;
    final index = gameList.indexWhere((g) => g.id == gd.id);

    if (index == -1) {
      games.value = [...games.value, gd];
      AppLog.i("Added game $gd");
    } else {
      final updated = List<GameData>.from(gameList);
      updated[index] = gd;
      games.value = updated;
      AppLog.i("Updated game $gd");
    }
  }

  Future<bool> remove (GameData gd) async {
    try {
      final dir = await getAppDir();
      final gameDir = Directory('${dir.path}${Platform.pathSeparator}games${Platform.pathSeparator}${gd.id}');
      
      if (await gameDir.exists()) {
        await gameDir.delete(recursive: true);
        games.value = games.value.where((g) => g.id != gd.id).toList();
        AppLog.i("Removed game ${gd.id}");
        return true;
      }
      return false;
    } catch (e) {
      AppLog.e("Error removing game ${gd.id}: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> getGameJsons(GameData gd) async {
    final jsonData = <String, dynamic>{};
    final dir = await getAppDir();
    final gameDir = Directory('${dir.path}${Platform.pathSeparator}games${Platform.pathSeparator}${gd.id}');

    if (!await gameDir.exists()) {
      return jsonData;
    }

    for (final entry in gameDir.listSync()) {
      if (entry is File && entry.path.toLowerCase().endsWith('.json')) {
        final content = await entry.readAsString();
        final filename = entry.path.split(Platform.pathSeparator).last;
        final key = filename.substring(0, filename.length - 5);
        jsonData[key] = jsonDecode(content);
      }
    }

    return jsonData;
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
            await GameData.generate(json)
          );
        }
      }
    }

    games = ValueNotifier<List<GameData>>(loadedGames);
    loaded = true;
    AppLog.i("${loadedGames.length} games loaded");
  }
}