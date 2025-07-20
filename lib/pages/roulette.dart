import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:roulette/managers/audio_player_manager.dart';
import 'package:roulette/models/resort.dart';
import 'package:url_launcher/url_launcher.dart';

class Roulette extends StatefulWidget {
  final List<Resort> resorts;
  const Roulette({Key? key, required this.resorts}) : super(key: key);

  @override
  _RouletteState createState() => _RouletteState();
}

class _RouletteState extends State<Roulette> {
  final StreamController<int> selected = StreamController<int>();
  int? selectedIndex;
  bool isSpinning = false;

  final pastelColors = [
    const Color(0xFFFFC1E3),
    const Color(0xFFB2EBF2),
    const Color(0xFFFFF59D),
    const Color(0xFFC8E6C9),
    const Color(0xFFD1C4E9),
    const Color(0xFFFFE0B2),
  ];
  final AudioPlayerManager audioPlayerManager = AudioPlayerManager();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  Future<void> onTapStart() async {
    if (isSpinning) return;
    setState(() => isSpinning = true);
    await audioPlayerManager.play(dotenv.get('roulette_audio_path'));
    final index = startSpin();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        selectedIndex = index;
        isSpinning = false;
      });
    });
  }

  int startSpin() {
    final idx = Fortune.randomInt(0, widget.resorts.length);
    selected.add(idx);
    return idx;
  }

  Future linkOfficial(String uri) async {
    final url = Uri.parse(uri);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'URLが見つかりません',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      );
    }
  }

  void initAudioPlayer() {
    audioPlayerManager.init();
  }

  void playAudio(String path) {
    audioPlayerManager.play(path);
  }

  @override
  void dispose() {
    selected.close();
    audioPlayerManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFFFF3F8);
    final wheelBorder = Colors.pink.shade100;
    final startButtonColor = Colors.pinkAccent;
    final resultChipColor = Colors.pink.shade200;
    final size = min(MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height * 0.6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFCFFAEB),
        elevation: 0,
        title: const Text(
          'Hoshino Roulette',
          style: TextStyle(
            color: Colors.pinkAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size,
            height: size,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: wheelBorder, width: 8),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SizedBox(
              width: size,
              height: size,
              child: FortuneWheel(
                animateFirst: false,
                selected: selected.stream,
                items: List.generate(widget.resorts.length, (i) {
                  final r = widget.resorts[i];
                  return FortuneItem(
                    child: Text(
                      r.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    style: FortuneItemStyle(
                      color: pastelColors[i % pastelColors.length],
                      borderColor: Colors.white,
                      borderWidth: 2,
                    ),
                  );
                }),
                indicators: [
                  FortuneIndicator(
                    alignment: const Alignment(0, -0.95),
                    child: TriangleIndicator(
                      height: 24,
                      width: 24,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isSpinning ? null : onTapStart,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  startButtonColor.withValues(alpha: isSpinning ? 0.9 : 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            ),
            child: Text(
              'Start!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white.withValues(alpha: isSpinning ? 0.9 : 1),
              ),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 48,
            child: Center(
              child: selectedIndex != null
                  ? ActionChip(
                      label: Text(
                        widget.resorts[selectedIndex!].name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: resultChipColor,
                      elevation: 4,
                      onPressed: () =>
                          linkOfficial(widget.resorts[selectedIndex!].url),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
