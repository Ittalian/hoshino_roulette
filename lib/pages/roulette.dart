import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:roulette/models/resort.dart';
import 'package:url_launcher/url_launcher.dart';

class Roulette extends StatefulWidget {
  final List<Resort> resorts;
  const Roulette({Key? key, required this.resorts}) : super(key: key);

  @override
  _RouletteState createState() => _RouletteState();
}

class _RouletteState extends State<Roulette> {
  StreamController<int> selected = StreamController<int>();
  int? selectedIndex;

  void onTapStart() {
    final index = startSpin();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        selectedIndex = index;
      });
    });
  }

  int startSpin() {
    final index = Fortune.randomInt(0, widget.resorts.length);
    selected.add(index);
    return index;
  }

  Future linkOfficial(String uri) async {
    var url = Uri.parse(uri);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'URLが見つかりません',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight * 0.6);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: size,
                height: size,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: FortuneWheel(
                    animateFirst: false,
                    selected: selected.stream,
                    items: [
                      for (var resort in widget.resorts)
                        FortuneItem(child: Text(resort.name)),
                    ],
                    indicators: [
                      FortuneIndicator(
                        alignment: Alignment(0, -0.95),
                        child: TriangleIndicator(
                          height: 24,
                          width: 24,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onTapStart,
              child: const Text('Start!'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: Center(
                child: selectedIndex != null
                    ? TextButton(
                        onPressed: () =>
                            linkOfficial(widget.resorts[selectedIndex!].url),
                        child: Text(
                          widget.resorts[selectedIndex!].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueAccent,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }
}
