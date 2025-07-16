import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String location;
  final DateTime date;
  final List<String> users;
  final String description;

  Task({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.users,
    required this.description,
  });

  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Task(
      id: doc.id,
      title: data['title']?.toString() ?? '',
      location: data['location']?.toString() ?? '',
      date: (data['date'] as Timestamp).toDate(),
      users: (data['users'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      description: data['description']?.toString() ?? '',
    );
  }
}
