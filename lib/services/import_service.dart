import 'dart:io';
import 'dart:convert';

import 'package:appdle/services/app_log.dart';
import 'package:appdle/services/game_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';

class ImportService {
  static Future<Map<String, dynamic>?> importGame() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result == null) return null;

    AppLog.i("Extracting new game");

    final file = File(result.files.single.path!);
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    ArchiveFile? dataFile;
    ArchiveFile? entriesFile;
    for (final item in archive) {
      if (item.name == 'data.json') dataFile = item;
      if (item.name == 'entries.json') entriesFile = item;
    }
    if (dataFile == null || entriesFile == null) {
      AppLog.e("Invalid game");
      AppLog.d("dataFile: $dataFile, entriesFile: $entriesFile");
      throw Exception("Invalid package");
    }

    AppLog.i("Reading new game");
    final data = jsonDecode(
      utf8.decode(dataFile.content as List<int>)
    );

    final gameId = data['id'];

    final dir = await GameRepository.getAppDir();
    final gameDir = Directory('${dir.path}${Platform.pathSeparator}games${Platform.pathSeparator}$gameId');

    if (!await gameDir.exists()) {
      await gameDir.create(recursive: true);
      AppLog.i('Creating new game directory:$gameDir');
    }

    for (final item in archive) {
      final outFile = File('${gameDir.path}${Platform.pathSeparator}${item.name}');
      if (item.isFile) {
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(item.content as List<int>);
      }
    }

    AppLog.i('Imported new game successfully:$gameId');
    return data;
  }
}