import 'package:appdle/localization/text_manager.dart';
import 'package:appdle/main.dart';
import 'package:appdle/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingsPage extends StatefulWidget {
    const SettingsPage({super.key});

    @override
    State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  
  void _showColorPickerDialog(BuildContext context, Color currentColor, Function(Color) onColorSelected) {
    Color tempColor = currentColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(""),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                tempColor = color;
              },
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hsvWithHue,
              labelTypes: const [],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(TextManager.get("CANCEL")),
            ),
            ElevatedButton(
              onPressed: () {
                onColorSelected(tempColor);
                setState(() {
                });
                Navigator.pop(context);
              },
              child: Text(TextManager.get("CONFIRM")),
            ),
          ],
        );
      },
    );
    onColorSelected(tempColor);
  }

  ListTile _createColorCard(String textKey, Color color, Function(Color) onColorSelected){
    return ListTile(
      leading: const Icon(Icons.palette),
      title: Text(TextManager.get(textKey)),
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
      ),
      onTap: () {
        _showColorPickerDialog(context, color, onColorSelected);
        setState(() {
        });
      }
    );
  }

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
                                            SettingsService.setLanguaje(value);
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
                                MyApp.of(context).toggleTheme(value);
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
                                    ,
                                ]
                            )
                        )
                    ),

                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        TextManager.get("ST_GAME_COLORS"),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    // Theme - Other three colors
                    Card(
                      child: _createColorCard("ST_GAME_COLOR_CORRECT", MyApp.of(context).correctColor, MyApp.of(context).changeCorrect)
                    ),
                    Card(
                      child: _createColorCard("ST_GAME_COLOR_WRONG", MyApp.of(context).wrongColor, MyApp.of(context).changeWrong)
                    ),
                    Card(
                      child: _createColorCard("ST_GAME_COLOR_NEUTRAL", MyApp.of(context).neutralColor, MyApp.of(context).changeNeutral)
                    )
                ]
            )
        );
    }
}