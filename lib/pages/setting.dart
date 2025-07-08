import 'package:flutter/material.dart';
import 'package:roulette/models/resort.dart';
import 'package:roulette/pages/home.dart';
import 'package:roulette/services/resort_service.dart';

class Setting extends StatefulWidget {
  final List<Resort> resorts;

  const Setting({
    required this.resorts,
  });

  @override
  State<Setting> createState() => SettingState();
}

class SettingState extends State<Setting> {
  List<Resort> resorts = [];

  Future<void> saveResort(List<Resort> resorts) async {
    final service = ResortService();
    await service.updateIsDone(resorts);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Home(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      resorts = widget.resorts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '行ったところにチェック',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 144, 205, 255),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: '保存',
        child: Text(
          '保存',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          await saveResort(resorts);
        },
      ),
      body: ListView.builder(
        itemCount: resorts.length,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
            value: resorts[index].isDone,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  resorts[index].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (val) {
              setState(() {
                resorts[index].isDone = val!;
              });
            },
          );
        },
      ),
    );
  }
}
