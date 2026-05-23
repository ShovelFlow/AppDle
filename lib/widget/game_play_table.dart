import 'package:appdle/main.dart';
import 'package:appdle/services/play_data.dart';
import 'package:flutter/material.dart';

class GamePlayTable extends StatefulWidget {
  const GamePlayTable({super.key, required this.playData});

  final PlayData playData;
  
  @override
  State<GamePlayTable> createState() => _GamePlayTableState();
}

const HEADER_PADDING = 10.0;
const CELL_HEIGHT = 80.0;
const CELL_WIDTH = 80.0;

class _GamePlayTableState extends State<GamePlayTable> {
  final List<String> _tries = [];

  @override
  void initState() {
    super.initState();
    _tries.addAll(widget.playData.guesses);
    widget.playData.tableNotifier.addListener(_notify);
  }
  @override
  void dispose() {
    widget.playData.tableNotifier.removeListener(_notify);
    super.dispose();
  }

  void _notify() {
    switch (widget.playData.tableNotication) {
      case TableNotification.guess:
        if (widget.playData.guesses.isNotEmpty) {
          setState(() {
            _tries.add(widget.playData.guesses.last);
          });
        }
        break;
      case TableNotification.reset:
        setState(() {
          _tries.clear();
        });
        break;
    }
  }

  Row generateRow(String guessKey) {
    final rowData = widget.playData.entries[guessKey];
    return Row(
      children: widget.playData.attributes.entries.map((entry) {
        String valueKey = _validString(rowData?[entry.key].toString());
        switch (entry.value) {
          case "name":
            return _cellBox(valueKey, Theme.of(context).cardColor);

          case "numeric":
            final double n1 = double.tryParse(widget.playData.currentGuess[entry.key].toString())??0.0;
            final double n2 = double.tryParse(valueKey)??0.0;
            if (n1 == n2) {
              return _cellBox(valueKey, MyApp.of(context).correctColor);
            } else {
              return _cellBoxNumeric(valueKey, n1 < n2);
            }
          default:
            if (widget.playData.currentGuess[entry.key].toString() == valueKey) {
              return _cellBox(valueKey, MyApp.of(context).correctColor);
            } else {
              return _cellBox(valueKey, MyApp.of(context).wrongColor);
            }
        }
      }).toList(),
    );
  }
  Container _cellBox(String text, Color backgroundColor) {
    return Container(
      width: CELL_WIDTH,
      height: CELL_HEIGHT,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  Container _cellBoxNumeric(String text, bool lower) {
    return Container(
      width: CELL_WIDTH,
      height: CELL_HEIGHT,
      decoration: BoxDecoration(
        color: MyApp.of(context).wrongColor,
      ),
      child:  Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.22,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Icon(
                lower ? Icons.keyboard_double_arrow_down : Icons.keyboard_double_arrow_up,
                color: Colors.black,
              ),
            ),
          ),

          Center(
            child: Text (
              text,
              textAlign: TextAlign.center,
            )
          ),
        ]
      ),
    );
  }
  String _validString(dynamic str) {
    if (str == null || str.toString().isEmpty) {
      return "-";
    }
    return str.toString();
  }

  @override
  Widget build(BuildContext context) {

    final cols = widget.playData.attributes.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: cols.length * CELL_WIDTH,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).dividerColor.withAlpha(25),
              padding: const EdgeInsets.symmetric(vertical: HEADER_PADDING),
              child: Row(
                children: cols.map((keyName) => SizedBox(
                  width: CELL_WIDTH,
                  child: Text(
                    keyName,
                    style: TextStyle(
                      color: Theme.of(context).disabledColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )).toList(),
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                itemCount: _tries.length,
                addRepaintBoundaries: true,
                itemBuilder: (context, index) {

                  return Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
                    ),
                    child: generateRow(_tries[index])
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}