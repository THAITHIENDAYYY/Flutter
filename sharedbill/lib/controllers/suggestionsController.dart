import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharedbill/services/auth.dart';

abstract class SuggestionsController {
  static Map<String, dynamic> _defaultSuggestions = {
    "names": [],
    "amounts": ["5", "10", "20", "50"],
    "descriptions": {"Food": 0, "Rent": 0, "A job well done": 0}
  };

  static Future<Map<String, dynamic>> fetchSuggestions() async {
    try {
      User? user = await Auth.getCurrentUser();
      if (user == null) return _defaultSuggestions;

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("suggestions")
          .doc(user.uid)
          .get();

      if (!doc.exists) return _defaultSuggestions;

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return {
        "names": List<String>.from(data["names"] ?? []),
        "amounts": List<String>.from(data["amounts"] ?? _defaultSuggestions["amounts"]),
        "descriptions": Map<String, int>.from(data["descriptions"] ?? _defaultSuggestions["descriptions"])
      };
    } catch (e) {
      print("Error fetching suggestions: $e");
      return _defaultSuggestions;
    }
  }

  static Future<void> updateSuggestions(Map<String, dynamic> suggestions) async {
    User? user = await Auth.getCurrentUser();
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("suggestions")
        .doc(user.uid)
        .set(suggestions);
  }
}
