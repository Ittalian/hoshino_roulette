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
  List<String> prefectureList = [];
  bool isLoading = false;

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

  Map<String, bool> activeRegion = {
    '関東': false,
    '東北': false,
    '中部': false,
    '近畿': false,
    '中国': false,
    '四国': false,
    '九州': false,
    'ALL': false,
  };

  bool showAdvanced = false;
  Set<String> selectedPrefs = {};

  @override
  void initState() {
    super.initState();
    _getPrefectures();
    _fetchResorts();
  }

  _getPrefectures() {
    List<String> results = [];
    prefectures.regionLabel.values.forEach((list) => results.addAll(list));
    setState(() {
      prefectureList = results;
    });
  }

  Future<void> _fetchResorts() async {
    setState(() => isLoading = true);
    allResorts = await ResortService().fetchAll();
    setState(() {
      resorts = allResorts;
      isLoading = false;
    });
  }

  void _toggleSelect(int i) {
    setState(() {
      resorts[i].isSelected = !resorts[i].isSelected;
    });
  }

  void _onRegionTap(String region) {
    final set = prefectures.regionLabel[region]!;
    setState(() {
      activeRegion[region] = true;
      if (region != 'ALL') {
        for (var r in resorts) {
          if (set.contains(r.prefecture)) {
            r.isSelected = true;
          }
        }
      }
    });
  }

  void _onPrefectureTap(String pref) {
    setState(() {
      if (!selectedPrefs.contains(pref)) {
        selectedPrefs.add(pref);
      }
      for (var r in resorts) {
        if (selectedPrefs.contains(r.prefecture)) {
          r.isSelected = true;
        }
      }
    });
  }

  List<Resort> get _selected => resorts.where((r) => r.isSelected).toList();

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFFFFF3F8);
    final appBarColor = const Color(0xFFCFFAEB);
    final pink = Colors.pinkAccent;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: const Text(
          'Hoshino Roulette',
          style: TextStyle(
            color: Colors.pinkAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: pink.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
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
                              shadowColor: pink.withValues(alpha: 0.3),
                              child: ListTile(
                                leading: Checkbox(
                                  activeColor: pink,
                                  value: r.isSelected,
                                  onChanged: (_) => _toggleSelect(i),
                                ),
                                title: Text(r.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(r.prefecture),
                                onTap: () => _toggleSelect(i),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: chipColors.entries
                  .take(4)
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ActionChip(
                          label: Text(
                            e.key,
                            style: TextStyle(
                              color: activeRegion[e.key]!
                                  ? Colors.white
                                  : const Color(0xFF424242),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: activeRegion[e.key]!
                              ? Colors.pinkAccent
                              : e.value,
                          elevation: 4,
                          onPressed: () => _onRegionTap(e.key),
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
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ActionChip(
                          label: Text(
                            e.key,
                            style: TextStyle(
                              color: activeRegion[e.key]!
                                  ? Colors.white
                                  : const Color(0xFF424242),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: activeRegion[e.key]!
                              ? Colors.pinkAccent
                              : e.value,
                          elevation: 4,
                          onPressed: () => _onRegionTap(e.key),
                        ),
                      ))
                  .toList(),
            ),
            SwitchListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('高度な設定'),
              activeColor: pink,
              value: showAdvanced,
              onChanged: (v) => setState(() => showAdvanced = v),
            ),
            if (showAdvanced)
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: prefectureList.map((pref) {
                      final sel = selectedPrefs.contains(pref);
                      return FilterChip(
                        label: Text(pref,
                            style: TextStyle(
                                fontSize: 12,
                                color: sel ? Colors.white : Colors.black)),
                        selected: sel,
                        selectedColor: pink,
                        backgroundColor: Colors.pink.shade50,
                        onSelected: (_) => _onPrefectureTap(pref),
                      );
                    }).toList(),
                  ),
                ),
              ),
            const Padding(padding: EdgeInsetsGeometry.only(top: 5)),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'reset',
                    backgroundColor: Colors.white,
                    foregroundColor: pink,
                    onPressed: () => setState(() {
                      resorts.forEach((r) => r.isSelected = false);
                      activeRegion.updateAll((k, v) => false);
                      selectedPrefs.clear();
                    }),
                    child: const Icon(Icons.clear),
                  ),
                  const SizedBox(width: 24),
                  FloatingActionButton(
                    heroTag: 'selectAll',
                    backgroundColor: Colors.white,
                    foregroundColor: pink,
                    onPressed: () => setState(() {
                      resorts.forEach((r) => r.isSelected = true);
                    }),
                    child: const Icon(Icons.select_all),
                  ),
                  const SizedBox(width: 24),
                  FloatingActionButton(
                    heroTag: 'start',
                    backgroundColor: pink,
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
