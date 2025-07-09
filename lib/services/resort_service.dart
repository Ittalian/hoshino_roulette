import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roulette/models/resort.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResortService {
  const ResortService();

  Future<List<Resort>> fetchAll() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Resort').get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Resort(
        resortId: doc.id,
        name: data['name'] as String,
        prefecture: data['prefecture'] as String,
        url: data['url'] as String,
        isDone: data['is_done'] as bool,
      );
    }).toList();
  }

  Future<int> syncAll() async {
    int syncCount = 0;
    const _sheetUrl = 'https://sheets.googleapis.com/v4/'
        'spreadsheets/1h6i60YFE9H_8e2G7dqqnYssXL0OyTbwxSixrwHgSLvk/'
        'values/fs_sheet?key=AIzaSyAnjvLueXWwDJ-nxmk48bh8IU3h9cjqSkc';

    final resp = await http.get(Uri.parse(_sheetUrl));
    if (resp.statusCode != 200) {
      throw Exception('スプレッドシート取得失敗: ${resp.statusCode}');
    }

    final Map<String, dynamic> data = json.decode(resp.body);
    final List<dynamic> rows = data['values'] as List<dynamic>;

    final batch = FirebaseFirestore.instance.batch();
    final coll = FirebaseFirestore.instance.collection('Resort');

    for (final r in rows) {
      if (r is List && r.length >= 2) {
        final prefecture = r[0]?.toString() ?? '';
        final name = r[1]?.toString() ?? '';
        final url = r[2]?.toString() ?? '';
        final isDone = false;

        final docRef = coll.doc();

        final snapshot = await coll
            .where('prefecture', isEqualTo: prefecture)
            .where('name', isEqualTo: name)
            .get();

        if (snapshot.docs.isEmpty) {
          batch.set(docRef, {
            'prefecture': prefecture,
            'name': name,
            'url': url,
            'is_done': isDone,
          });
          syncCount++;
        }
      }
    }

    await batch.commit();

    return syncCount;
  }

  Future<void> updateIsDone(List<Resort> resorts) async {
    final coll = FirebaseFirestore.instance.collection('Resort');
    for (var resort in resorts) {
      coll.doc(resort.resortId).update({
        'is_done': resort.isDone,
      });
    }
  }
}
