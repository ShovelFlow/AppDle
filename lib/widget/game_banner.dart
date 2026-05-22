import 'package:flutter/material.dart';

class GameBanner extends StatelessWidget {
  final String name;
  final String author;
  final String bannerPath;
  final Color color;
  final VoidCallback? onTap;

  const GameBanner({
    super.key,
    required this.name,
    required this.author,
    required this.bannerPath,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 250,
          height: 140,
          child: Stack(
            fit: StackFit.expand,
            children: [

              Container(
                color: color,
              ),

              if (bannerPath.isNotEmpty)
                Image.asset(
                  bannerPath,
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
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(author),
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