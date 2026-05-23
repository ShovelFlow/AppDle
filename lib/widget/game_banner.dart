import 'dart:io';

import 'package:appdle/services/game_data.dart';
import 'package:flutter/material.dart';

class GameBanner extends StatelessWidget {
  final GameData game;
  final VoidCallback? onTap;

  const GameBanner({
    super.key,
    required this.game,
    this.onTap,
  });

  
  Color _parseColor(String value) {
    final hex = value.replaceFirst('#', '');
    final normalized = hex.length == 6 ? 'FF$hex' : hex;
    return Color(int.parse(normalized, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          child: Stack(
            fit: StackFit.expand,
            children: [

              Container(
                color: _parseColor(game.bannerColor),
              ),

              if (game.bannerImage.isNotEmpty)
                Image.file(
                  File(game.bannerImage),
                  fit: BoxFit.cover,
                ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.end,
                  children: [
                    Text(
                      game.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _parseColor(game.bannerTextColor),
                      ),
                    ),

                    Text(
                      game.author, 
                      style: TextStyle(
                        color: _parseColor(game.bannerTextColor),
                      ),
					),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}