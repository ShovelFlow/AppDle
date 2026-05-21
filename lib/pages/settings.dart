import 'package:appdle/localization/text_manager.dart';
import 'package:appdle/main.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
    const SettingsPage({super.key});

    @override
    State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
    @override
    Widget build(BuildContext context) {
        final appState = MyApp.of(context);

        final colors = [
            Colors.cyanAccent,
            Colors.blue,
            Colors.green,
            Colors.purple,
            Colors.red,
            Colors.orange,
            Colors.yellow,
        ];

        return Scaffold(
            appBar: AppBar(
                title: Text(TextManager.get("MN_SETTINGS")),
            ),
            
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [

                    // Language
                    Card(
                        child: ListTile(
                            leading: const Icon(Icons.language),
                            title: Text(TextManager.get("ST_LANGUAGE")),
                            trailing: DropdownButton<String>(
                                value: TextManager.language,
                                items: const [
                                    DropdownMenuItem(value: "es", child: Text("Español")),
                                    DropdownMenuItem(value: "en", child: Text("English")),
                                ],
                                onChanged: (value) {
                                    if (value != null) {
                                        setState(() {
                                            TextManager.changeLanguage(value);
                                        });
                                    }
                                }
                            )
                        )
                    ),

                    const SizedBox(height: 12),

                    // Theme
                    Card(
                        child: SwitchListTile(
                            secondary: const Icon(Icons.color_lens_outlined),
                            title: Text(TextManager.get("ST_THEME")),
                            value: appState.darkMode,
                            onChanged: (value) {
                                setState(() {
                                    MyApp.of(context).toggleTheme(value);
                                });
                            }
                        )
                    ),
                    // Theme - Main color
                    Card(
                        child: SizedBox(
                            height: 50,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                    for (final color in colors)
                                        IconButton(
                                            onPressed: () {
                                                MyApp.of(context).changePrimary(color);
                                            },
                                            icon: Icon(Icons.circle, color: color),
                                        )
                                ]
                            )
                        )
                    ),
                ]
            )
        );
    }
}