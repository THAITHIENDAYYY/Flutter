import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group.dart';
import '../models/expense.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createGroup(String name, List<String> members) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('User not authenticated');

      final groupRef = await _firestore.collection('groups').add({
        'name': name,
        'members': members,
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Add group reference to each member's groups
      for (final memberId in members) {
        await _firestore.collection('users').doc(memberId).update({
          'groups': FieldValue.arrayUnion([groupRef.id]),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Group>> getUserGroups() {
    final user = currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('groups')
        .where('members', arrayContains: user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Group(
          id: doc.id,
          name: data['name'],
          members: List<String>.from(data['members']),
          createdBy: data['createdBy'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  Future<void> addExpense(
    String groupId,
    String title,
    double amount,
    List<String> splitBetween,
  ) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore.collection('expenses').add({
        'groupId': groupId,
        'title': title,
        'amount': amount,
        'paidBy': user.uid,
        'splitBetween': splitBetween,
        'date': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Expense>> getGroupExpenses(String groupId) {
    return _firestore
        .collection('expenses')
        .where('groupId', isEqualTo: groupId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Expense(
          id: doc.id,
          title: data['title'],
          amount: data['amount'].toDouble(),
          paidBy: data['paidBy'],
          splitBetween: List<String>.from(data['splitBetween']),
          date: (data['date'] as Timestamp).toDate(),
          groupId: data['groupId'],
        );
      }).toList();
    });
  }
} 