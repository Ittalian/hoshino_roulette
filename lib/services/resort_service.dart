import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roulette/models/resort.dart';

class ResortService {
  const ResortService();

  Future<List<Resort>> fetchAll() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('Resort').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Resort(
          resortId: doc.id,
          name: data['name'] as String,
          prefecture: data['prefecture'] as String,
          isDone: data['is_done'] as bool
        );
      }).toList();
  }
}