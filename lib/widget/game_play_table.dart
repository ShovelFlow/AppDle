import 'package:appdle/services/play_data.dart';
import 'package:flutter/material.dart';

class GamePlayTable extends StatefulWidget {
  const GamePlayTable({super.key, required this.playData});

  final PlayData playData;
  
  @override
  State<GamePlayTable> createState() => _GamePlayTableState();
}

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
    final cols = widget.playData.attributes.keys.toList();
    final rowData = widget.playData.entries[guessKey];
    rowData?.addAll({"name":guessKey});

    return Row(
      children: cols.map((colName) {
        return SizedBox(
          width: 80,
          child: Text(
            _validString(rowData?[colName].toString()),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _validString(dynamic str) {
    if (str != null) {
      return str.toString();
    }
    return "-";
  }

  @override
  Widget build(BuildContext context) {

    final cols = widget.playData.attributes.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        // Calculamos el ancho exacto que sumarán todas tus columnas juntas
        width: cols.length * 80.0,
        child: Column(
          children: [
            // 1. ENCABEZADO FIJO
            Container(
              color: Theme.of(context).dividerColor.withAlpha(25),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: cols.map((keyName) => SizedBox(
                          width: 80,
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
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
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