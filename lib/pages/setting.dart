import 'package:flutter/material.dart';
import 'package:roulette/models/resort.dart';
import 'package:roulette/pages/home.dart';
import 'package:roulette/services/resort_service.dart';

class Setting extends StatefulWidget {
  final List<Resort> resorts;
  const Setting({Key? key, required this.resorts}) : super(key: key);

  @override
  State<Setting> createState() => SettingState();
}

class SettingState extends State<Setting> {
  late List<Resort> resorts;

  @override
  void initState() {
    super.initState();
    resorts = widget.resorts;
  }

  Future<void> saveResort(List<Resort> resorts) async {
    final service = ResortService();
    await service.updateIsDone(resorts);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFFFF3F8);    
    const appBarColor = Color(0xFFCFFAEB);
    final shadowColor = Colors.pinkAccent.withValues(alpha: 0.2);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '行ったところにチェック',
          style: TextStyle(
            color: Colors.pinkAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: resorts.length,
              itemBuilder: (context, index) {
                final r = resorts[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: r.isDone ? 6 : 2,
                  shadowColor: shadowColor,
                  child: CheckboxListTile(
                    value: r.isDone,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.pinkAccent,
                    title: Text(
                      r.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        r.isDone = val ?? false;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        label: const Text(
          '保存',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          await saveResort(resorts);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
