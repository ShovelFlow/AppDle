import 'package:appdle/localization/text_manager.dart';
import 'package:appdle/services/play_data.dart';
import 'package:flutter/material.dart';

class GamePlayKeyboard extends StatefulWidget {
  const GamePlayKeyboard({super.key, required this.playData});

  final PlayData playData;
  
  @override
  State<GamePlayKeyboard> createState() => _GamePlayKeyboardState();
}

class _GamePlayKeyboardState extends State<GamePlayKeyboard> {
  String _currentInput = "";

  @override
  void initState() {
    super.initState();
    widget.playData.tableNotifier.addListener(_notify);
  }
  @override
  void dispose() {
    widget.playData.tableNotifier.removeListener(_notify);
    super.dispose();
  }

  void _onKeyPressed(String key) {
    setState(() {
      if (key == "ENTER") {
        if (_currentInput.isNotEmpty) {
          _guessWord();
          _currentInput = "";
        }
      } else if (key == "BACK") {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
        }
      } else {
        _currentInput += key;
      }
    });
  }

  void _notify() {
    if (widget.playData.tableNotication == TableNotification.reset) {
      setState(() {});
    }
  }

  void _guessWord() {
    widget.playData.guess(_currentInput);
  }

  void _resetButton() {
    widget.playData.restartPlay();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.playData.finished) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          children:[
            Text(
              TextManager.get("PLAY_WIN"),
              style: Theme.of(context).textTheme.headlineMedium
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _resetButton(),
                child: const Icon(Icons.restart_alt),
              ),
            ),
          ] 
        )
      );
    } else {
      return Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                style: BorderStyle.solid,
                color: Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            child: _currentInput.isNotEmpty 
                ? Text(_currentInput)
                : Text(
                    "Introduce el texto aquí...",
                    style: TextStyle(color: Theme.of(context).disabledColor),
                  ),
          ),
          _buildKeyboard(),
        ],
      );
    }
  }

  Widget _buildKeyboard() {
    const List<String> row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
    const List<String> row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
    const List<String> row3 = ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'BACK'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          _buildKeyboardRow(row1),
          _buildKeyboardRow(row2),
          _buildKeyboardRow(row3),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        return Expanded(
          flex: key.length > 1 ? 2 : 1,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () => _onKeyPressed(key),
              child: Text(key),
            ),
          ),
        );
      }).toList(),
    );
  }
}