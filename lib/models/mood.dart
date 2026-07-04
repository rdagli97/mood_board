import 'package:cloud_firestore/cloud_firestore.dart';

class Mood {
  final String id;
  final String emoji;
  final String note;
  final String userEmail;
  final DateTime createdAt;

  Mood({
    required this.id,
    required this.emoji,
    required this.note,
    required this.userEmail,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'note': note,
      'userEmail': userEmail,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Mood.fromMap(String id, Map<String, dynamic> map) {
    return Mood(
      id: id,
      emoji: map['emoji'] ?? '',
      note: map['note'] ?? '',
      userEmail: map['userEmail'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
