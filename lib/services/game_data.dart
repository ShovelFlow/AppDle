import 'package:appdle/services/app_log.dart';
import 'package:appdle/services/game_repository.dart';
import 'package:path/path.dart' as p;

class GameData {
	final String id;
	final String name;
	final String author;
	final String version;

	final String bannerColor;
	final String bannerImage;
	final String bannerTextColor;

	GameData({
		required this.id,
		required this.name,
		required this.author,
		required this.version,

		required this.bannerColor,
		required this.bannerImage,
		required this.bannerTextColor,
	});

  static Future<GameData> generate(json) async {
    final dir = await GameRepository.getAppDir();
    return GameData(
      id: json["id"],
      name: json["name"],
      author: json["author"],
      version: json["version"],

			bannerImage: p.join(dir.path, 'games', json["id"], p.normalize(json["banner"]["banner_image"])),
			bannerColor: json["banner"]["background_color"] ?? "#000000",
			bannerTextColor: json["banner"]["text_color"] ?? "#ffffff",
	  );
  }
}