import 'package:firebase_core/firebase_core.dart';
import 'package:roulette/models/resort.dart';
import 'package:roulette/roulette.dart';
import 'package:roulette/services/resort_service.dart';
import 'config/firebase_options.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Resort> resorts = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    fetchResorts();
  }

  Future<void> fetchResorts() async {
    final resortService = ResortService();
    resorts = await resortService.fetchAll();
    setState(() {
      resorts = resorts;
    });
  }

  void resetElem() {
    setState(() {
      for (var resort in resorts) {
        resort.isSelected = false;
      }
    });
  }

  void allSelectElem() {
    setState(() {
      for (var resort in resorts) {
        resort.isSelected = true;
      }
    });
  }

  List<Resort> getSelectedResort() {
    return resorts.where((resort) => resort.isSelected ?? false).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.blue[100],
                child: Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: resorts.isEmpty
                          ? const CircularProgressIndicator()
                          : ListView.builder(
                              itemCount: resorts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CheckboxListTile(
                                  value: resorts[index].isSelected ?? false,
                                  title: Text(
                                    resorts[index].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  onChanged: (val) {
                                    setState(() {
                                      resorts[index].isSelected = val!;
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(50),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                heroTag: 'reset',
                                child: Icon(Icons.toggle_off_outlined),
                                onPressed: () {
                                  resetElem();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                heroTag: 'allSelect',
                                child: Icon(Icons.toggle_on),
                                onPressed: () {
                                  allSelectElem();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                backgroundColor: Colors.pink[300],
                                heroTag: 'start',
                                child: Icon(Icons.play_arrow),
                                onPressed: () {
                                  final selectedResorts = getSelectedResort();
                                  if (selectedResorts.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Roulette(resorts: selectedResorts),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
