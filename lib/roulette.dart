import 'package:flutter/material.dart';
import 'package:roulette/models/resort.dart';

class Roulette extends StatefulWidget {
  final List<Resort> resorts;

  const Roulette({
    required this.resorts,
  });

  @override
  State<Roulette> createState() => RouletteState();
}

class RouletteState extends State<Roulette> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var resort in widget.resorts) Text(resort.name),
        ],
      ),
    );
  }
}
