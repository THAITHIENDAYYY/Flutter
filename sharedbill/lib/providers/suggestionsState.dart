import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:sharedbill/controllers/suggestionsController.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SuggestionsState with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<String> _suggestions = [];
  List<String> get suggestions => _suggestions;

  SuggestionsState() {
    loadSuggestions();
  }

  Future<void> loadSuggestions() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('suggestions')
          .where('uid', isEqualTo: user.uid)
          .get();

      _suggestions = snapshot.docs
          .map((doc) => doc['name'] as String?)
          .where((name) => name != null)
          .cast<String>()
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error loading suggestions: $e');
    }
  }

  Future<void> addSuggestion(String name) async {
    final User? user = _auth.currentUser;
    if (user == null || name.trim().isEmpty) return;

    if (!_suggestions.contains(name.trim())) {
      try {
        await _firestore.collection('suggestions').add({
          'name': name.trim(),
          'uid': user.uid,
        });

        _suggestions.add(name.trim());
        _suggestions.sort(); // Optional: keep suggestions sorted
        notifyListeners();
      } catch (e) {
        print('Error adding suggestion: $e');
      }
    }
  }

  Future<void> removeSuggestion(String name) async {
    final User? user = _auth.currentUser;
    if (user == null || name.trim().isEmpty) return;

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('suggestions')
          .where('name', isEqualTo: name.trim())
          .where('uid', isEqualTo: user.uid)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      _suggestions.remove(name.trim());
      notifyListeners();
    } catch (e) {
      print('Error removing suggestion: $e');
    }
  }
}

class Suggestions extends ChangeNotifier {
  static const int _NAMES_LEN = 3;
  static const int _DESCRIPTIONS_LEN = 3;
  Map<String, dynamic> _savedSuggestions = {
    "names": [],
    "amounts": ["5", "10", "20", "50"],
    "descriptions": Map<String, int>()
  };

  Suggestions() {
    _fetchFromDatabase();
  }

  Map<String, List<String>> get suggestions {
    /* only need to convert descriptions from freq map to list */
    Map<String, List<String>> formatted = {};
    formatted["names"] = (_savedSuggestions["names"] as List<dynamic>).cast<String>();
    formatted["amounts"] = (_savedSuggestions["amounts"] as List<dynamic>).cast<String>();
    formatted["descriptions"] = _freqMapToList(
      _savedSuggestions["descriptions"] as Map<String, int>,
      _DESCRIPTIONS_LEN,
    );
    return formatted;
  }

  void _fetchFromDatabase() async {
    Map<String, dynamic>? suggestions =
        await SuggestionsController.fetchSuggestions();
    if (suggestions != null) _savedSuggestions = suggestions;
    notifyListeners();
  }

  void updateSuggestions(String name, String amount, String description) {
    _updateNames(name);
    _updateDescriptions(description);
    notifyListeners();
    SuggestionsController.updateSuggestions(_savedSuggestions);
  }

  void _updateNames(String name) {
    /* Use queues as LRU cache */
    DoubleLinkedQueue<String> names =
        DoubleLinkedQueue.of(suggestions["names"] ?? []);
    if (names.contains(name))
      names.remove(name);
    else if (names.length >= _NAMES_LEN) names.removeLast();
    names.addFirst(name);
    _savedSuggestions["names"] = List<String>.from(names);
  }

  void _updateDescriptions(String description) {
    Map<String, int> descriptionsMap = _savedSuggestions["descriptions"] as Map<String, int>;
    if (descriptionsMap.containsKey(description))
      descriptionsMap[description] = (descriptionsMap[description] ?? 0) + 1;
    else {
      if (descriptionsMap.length >= 6) {
        /* remove the least frequent entry */
        int minimum = descriptionsMap.values.reduce(min);
        for (String key in descriptionsMap.keys) {
          if (descriptionsMap[key] == minimum) {
            descriptionsMap.remove(key);
            break;
          }
        }
      }
      descriptionsMap[description] = 1;
    }
  }

  void removeName(String name) {
    (_savedSuggestions["names"] as List<dynamic>).remove(name);
    notifyListeners();
    SuggestionsController.updateSuggestions(_savedSuggestions);
  }

  void removeDescription(String description) {
    (_savedSuggestions["descriptions"] as Map<String, int>).remove(description);
    print(_savedSuggestions["descriptions"]);
    notifyListeners();
    SuggestionsController.updateSuggestions(_savedSuggestions);
  }

  /// returns k most frequent items in frequency map
  List<String> _freqMapToList(Map<String, int> map, int k) {
    List<int> frequencies = map.values.toList();
    k = min(k, frequencies.length);
    frequencies.sort((a, b) => b.compareTo(a)); // descending
    Map<String, int> frequencyMapCopy = Map<String, int>.from(map);
    List<String> descriptions = [];
    for (int i = 0; i < k; i++) {
      int current = frequencies[i];
      String descriptionToAdd = frequencyMapCopy.keys
          .firstWhere((key) => frequencyMapCopy[key] == current);
      descriptions.add(descriptionToAdd);
      frequencyMapCopy.remove(descriptionToAdd);
    }
    return descriptions;
  }
}
