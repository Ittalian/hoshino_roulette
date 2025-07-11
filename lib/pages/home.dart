import '../models/resort.dart';
import 'admin.dart';
import 'roulette.dart';
import 'setting.dart';
import 'package:flutter/material.dart';
import '../services/resort_service.dart';
import '../utils/prefectures.dart' as prefectures;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Resort> allResorts = [];
  List<Resort> resorts = [];
  bool isDisplayAll = false;

  @override
  void initState() {
    super.initState();
    _fetchResorts();
  }

  Future<void> _fetchResorts() async {
    allResorts = await ResortService().fetchAll();
    setState(() {
      resorts = allResorts.where((resort) => !resort.isDone).toList();
    });
  }

  void _toggleSelect(int i) {
    setState(() => resorts[i].isSelected = !resorts[i].isSelected);
  }

  void _selectByRegion(String region) {
    final set = prefectures.regionLabel[region]!;
    setState(() {
      for (var r in resorts) {
        if (set.contains(r.prefecture)) r.isSelected = true;
      }
    });
  }

  void _selectByUndone() {
    if (isDisplayAll) {
      setState(() {
        final targetResorts = resorts.where((resort) => !resort.isDone).toList();
        final expectResorts = resorts.where((resort) => resort.isDone).toList();
        resorts = targetResorts;
        for (var resort in expectResorts) {
          print(resort.name);
          resort.isSelected = false;
        }
        isDisplayAll = false;
      });
    } else {
      setState(() {
        resorts = allResorts;
        isDisplayAll = true;
      });
    }
  }

  List<Resort> get _selected => resorts.where((r) => r.isSelected).toList();

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFFFFF3F8);
    final appBarColor = const Color(0xFFCFFAEB);
    final chipColors = {
      '関東': Colors.pink.shade100,
      '東北': Colors.blue.shade100,
      '中部': Colors.green.shade100,
      '近畿': Colors.orange.shade100,
      '中国': Colors.grey.shade300,
      '四国': Colors.teal.shade100,
      '九州': Colors.purple.shade100,
      'ALL': Colors.pink.shade200,
    };

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: const Text('Hoshino Roulette',
            style: TextStyle(color: Colors.pinkAccent)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.pinkAccent),
            onPressed: () => showMenu<String>(
              context: context,
              position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
              items: const [
                PopupMenuItem(
                    value: 'admin',
                    child:
                        Text('管理', style: TextStyle(color: Colors.pinkAccent))),
                PopupMenuItem(
                    value: 'setting',
                    child:
                        Text('設定', style: TextStyle(color: Colors.pinkAccent))),
              ],
            ).then((v) {
              if (v == 'admin') {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Admin()));
              }
              if (v == 'setting') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Setting(resorts: allResorts)));
              }
            }),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: resorts.length,
                    itemBuilder: (ctx, i) {
                      final r = resorts[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: r.isSelected ? 6 : 2,
                        shadowColor: Colors.pinkAccent.withValues(alpha: 0.5),
                        child: ListTile(
                          leading: Checkbox(
                            activeColor: Colors.pinkAccent,
                            value: r.isSelected,
                            onChanged: (_) => _toggleSelect(i),
                          ),
                          title: Text(r.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(r.prefecture),
                          onTap: () => _toggleSelect(i),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: chipColors.entries
                        .take(4)
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ActionChip(
                                label: Text(
                                  e.key,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 66, 66, 66),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: e.value,
                                elevation: 4,
                                onPressed: () {
                                  _selectByRegion(e.key);
                                },
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: chipColors.entries
                        .skip(4)
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ActionChip(
                                label: Text(
                                  e.key,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 66, 66, 66),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: e.value,
                                elevation: 4,
                                onPressed: () {
                                  if (e.key == 'ALL') {
                                    _selectByUndone();
                                  } else {
                                    _selectByRegion(e.key);
                                  }
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'reset',
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pinkAccent,
                    onPressed: () => setState(
                        () => resorts.forEach((r) => r.isSelected = false)),
                    child: const Icon(Icons.clear),
                  ),
                  const Padding(padding: EdgeInsetsGeometry.only(left: 20)),
                  FloatingActionButton(
                    heroTag: 'all',
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pinkAccent,
                    onPressed: () => setState(
                        () => resorts.forEach((r) => r.isSelected = true)),
                    child: const Icon(Icons.select_all),
                  ),
                  const Padding(padding: EdgeInsetsGeometry.only(right: 20)),
                  FloatingActionButton(
                    heroTag: 'start',
                    backgroundColor: Colors.pinkAccent,
                    onPressed: () {
                      final sel = _selected;
                      if (sel.length > 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Roulette(resorts: sel)));
                      }
                    },
                    child: const Icon(Icons.play_arrow),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
