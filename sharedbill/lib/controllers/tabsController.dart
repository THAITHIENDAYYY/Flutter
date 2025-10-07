import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharedbill/services/auth.dart';
import 'package:flutter/services.dart';

class TabsController {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> createTab({
    required String name,
    required double amount,
    required String description,
    required bool userOwesFriend,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('tabs').add({
      'name': name,
      'amount': amount,
      'description': description,
      'userOwesFriend': userOwesFriend,
      'time': FieldValue.serverTimestamp(),
      'closed': false,
      'uid': user.uid,
    });
  }

  static Future<void> closeTab(String documentID) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('tabs').doc(documentID).update({
      'closed': true,
      'timeClosed': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> reopenTab(String documentID) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('tabs').doc(documentID).update({
      'closed': false,
      'timeClosed': null,
    });
  }

  static Future<void> deleteTab(String documentID) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('tabs').doc(documentID).delete();
  }

  static Future<void> updateTabAmount(String documentID, double amount) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('tabs').doc(documentID).update({
      'amount': amount,
    });
  }

  static Stream<QuerySnapshot> getTabsStream() {
    final User? user = _auth.currentUser;
    if (user == null) {
      return Stream.empty();
    }

    return _firestore
        .collection('tabs')
        .where('uid', isEqualTo: user.uid)
        .orderBy('time', descending: true)
        .snapshots();
  }

  static Future<void> closeAllTabs(Iterable<DocumentSnapshot> tabs) async {
    WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    for (var t in tabs) {
      writeBatch.update(t.reference, {"closed": true, "timeClosed": DateTime.now()});
    }
    await writeBatch.commit();
    HapticFeedback.mediumImpact();
  }

  static Future<void> deleteAllTabs(List<String> tabIds) async {
    WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    for (String id in tabIds) {
      writeBatch.delete(_firestore.collection('tabs').doc(id));
    }
    await writeBatch.commit();
    HapticFeedback.mediumImpact();
  }
}
