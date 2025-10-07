import 'package:cloud_firestore/cloud_firestore.dart';

class TabModel {
  final String id;
  final String uid;
  final String name;
  final double amount;
  final String description;
  final bool userOwesFriend;
  final bool isClosed;
  final DateTime time;

  TabModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.amount,
    required this.description,
    required this.userOwesFriend,
    required this.isClosed,
    required this.time,
  });

  factory TabModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TabModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      userOwesFriend: data['userOwesFriend'] ?? false,
      isClosed: data['isClosed'] ?? false,
      time: (data['time'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
} 