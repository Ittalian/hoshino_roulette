import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:roulette/models/resort.dart';

class Roulette extends StatefulWidget {
  final List<Resort> resorts;
  const Roulette({Key? key, required this.resorts}) : super(key: key);

  @override
  _RouletteState createState() => _RouletteState();
}

class _RouletteState extends State<Roulette> {
  StreamController<int> selected = StreamController<int>();
  int? selectedIndex;

  void startSpin() {
    setState(() {
      final index = Fortune.randomInt(0, widget.resorts.length);
      setState(() {
        selectedIndex = index;
      });
      selected.add(index);
    });
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            Expanded(
              child: FortuneWheel(
                animateFirst: false,
                selected: selected.stream,
                items: [
                  for (var resort in widget.resorts)
                    FortuneItem(child: Text(resort.name)),
                ],
                indicators: [
                  FortuneIndicator(
                    alignment: Alignment(0, -0.54),
                    child: TriangleIndicator(
                      height: 24,
                      width: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(onPressed: () => startSpin(), child: Text('Start!')),
            const Padding(padding: EdgeInsetsGeometry.only(bottom: 20)),
            selectedIndex == null ? Text('')  : Text(widget.resorts[selectedIndex!].name),
            const Padding(padding: EdgeInsetsGeometry.only(bottom: 100)),
          ],
        ),
      ),
    );
  }
}
