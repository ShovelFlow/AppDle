import 'dart:math';

import 'package:appdle/services/app_log.dart';
import 'package:flutter/material.dart';

enum TableNotification { guess, reset }

class PlayData {
  Map<String, String> attributes = {};
  Map<String, dynamic> currentGuess = {};
  Map<String, Map<String, dynamic>> entries = {};
  List<String> guesses = [];
  bool finished = false;

  final ValueNotifier<int> tableNotifier = ValueNotifier<int>(1);
  TableNotification tableNotication = TableNotification.reset;

  PlayData();

  void fillData(dynamic json) {
    AppLog.i("Creating play data $json");
    
    final keys = json['data']['game']['keys'];
    if (keys is Map) {
      final sortedKeys = keys.entries.toList();
      sortedKeys.sort((a, b) {
        final orderA = a.value['order'] ?? 99;
        final orderB = b.value['order'] ?? 99;
        return orderA.compareTo(orderB);
      });
      if (json['data']['game']['show_text']??false == true) {
        attributes["name"] = "name";
      }
      for (var entry in sortedKeys) {
        attributes[entry.key.toString()] = entry.value['type'];
      }
    }

    final jsonEntries = json['entries'];
    if (jsonEntries is Map) {
      final listEntries = jsonEntries.entries.toList();
      for (var entry in listEntries) {
        entries[entry.key.toString().toUpperCase()] = Map<String, dynamic>.from(jsonEntries[entry.key]);
      }
    }
    restartPlay();
  }

  void restartPlay() {
    if (entries.isEmpty) {return;}

    guesses = [];
    finished = false;

    final entriesList = entries.entries.toList();
    final randomGuess = entriesList[Random().nextInt(entriesList.length)];
    currentGuess = randomGuess.value;
    currentGuess.addAll({'name': randomGuess.key});

    tableNotication = TableNotification.reset;
    tableNotifier.value = 0;

    AppLog.d("New Guess: ${currentGuess.toString()}");
  }

  void guess(String guess) {
    AppLog.d("Player guessed: $guess");
    if (!entries.containsKey(guess)) {
      return;
    }
    if (guesses.contains(guess)) {
      return;
    }
    guesses.add(guess);
    if (guess.compareTo(currentGuess["name"].toString()) == 0) {
      finished = true;
    }
    tableNotication = TableNotification.guess;
    tableNotifier.value++;
  }
}