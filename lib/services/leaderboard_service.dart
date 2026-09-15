import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class LeaderboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUserXp(int xp, String name) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _db.collection('leaderboard').doc(user.uid).set({
        'name': name,
        'xp': xp,
        'avatar': '😎',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating leaderboard XP: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getTopPlayers() {
    return _db
        .collection('leaderboard')
        .orderBy('xp', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return data;
      }).toList();
    });
  }
}
