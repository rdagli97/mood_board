import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mood_board/models/mood.dart';

class MoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Mood
  Future<void> addMood(Mood mood) async {
    await _firestore.collection('moods').add(mood.toMap());
  }

  // Watch moods
  Stream<List<Mood>> getMoods() {
    return _firestore
        .collection('moods')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Mood.fromMap(doc.id, doc.data());
          }).toList();
        });
  }
}