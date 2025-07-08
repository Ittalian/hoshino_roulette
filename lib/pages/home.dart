import 'package:flutter/material.dart';
import 'package:roulette/models/resort.dart';
import 'package:roulette/pages/admin.dart';
import 'package:roulette/pages/roulette.dart';
import 'package:roulette/pages/setting.dart';
import 'package:roulette/services/resort_service.dart';
import '../utils/prefectures.dart' as prefectures;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  void selectByRegion(String region) {
    final selectedResorts = resorts.where((resort) =>
        prefectures.regionLabel[region]!.contains(resort.prefecture));
    setState(() {
      for (var resort in selectedResorts) {
        resort.isSelected = !resort.isSelected;
      }
    });
  }

  void selectByIsDone() {
    final selectedResorts = resorts.where((resort) => !resort.isDone);
    setState(() {
      for (var resort in selectedResorts) {
        resort.isSelected = !resort.isSelected;
      }
    });
  }

  List<Resort> getSelectedResort() {
    return resorts.where((resort) => resort.isSelected).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Roulette',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 144, 205, 255),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'admin':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Admin(),
                    ),
                  );
                  break;
                case 'setting':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Setting(
                        resorts: resorts,
                      ),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'admin',
                child: Text('管理'),
              ),
              const PopupMenuItem(
                value: 'setting',
                child: Text('設定'),
              ),
            ],
          ),
        ],
      ),
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
                      flex: 6,
                      child: ListView.builder(
                        itemCount: resorts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                            value: resorts[index].isSelected,
                            title: Text(
                              resorts[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
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
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.cyanAccent,
                                    heroTag: '関東地方',
                                    child: Text(
                                      '関東',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () => selectByRegion('関東'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.blue,
                                    heroTag: '東北地方',
                                    child: Text(
                                      '東北',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () => selectByRegion('東北'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.green,
                                    heroTag: '中部地方',
                                    child: Text(
                                      '中部',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () => selectByRegion('中部'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.orange,
                                    heroTag: '近畿地方',
                                    child: Text(
                                      '近畿',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () => selectByRegion('近畿'),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.grey,
                                    heroTag: '中国地方',
                                    child: Text(
                                      '中国',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () => selectByRegion('中国'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.lightGreen,
                                    heroTag: '四国地方',
                                    child: Text(
                                      '四国',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () => selectByRegion('四国'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.yellow,
                                    heroTag: '九州地方',
                                    child: Text(
                                      '九州',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () => selectByRegion('九州'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.redAccent,
                                    heroTag: 'まだ行っていない',
                                    child: Text(
                                      '未到',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () => selectByIsDone(),
                                  ),
                                ),
                              ],
                            ),
                            Row(
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
                                      final selectedResorts =
                                          getSelectedResort();
                                      if (selectedResorts.length > 1) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Roulette(
                                                resorts: selectedResorts),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
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
