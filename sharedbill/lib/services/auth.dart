import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class Auth {
  static Future<String> signIn(String email, String password) async {
    UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    User user = result.user!;
    return user.uid;
  }

  static Future<String> signUp(String email, String password) async {
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User user = result.user!;
    return user.uid;
  }

  static Future<String?> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();
      if (googleAccount == null) return null;

      final GoogleSignInAuthentication googleAuth = 
          await googleAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult = 
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user == null) return null;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User? currentUser = FirebaseAuth.instance.currentUser;
      assert(user.uid == currentUser?.uid);
      return user.uid;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<void> googleSignOut() async {
    await GoogleSignIn().signOut();
  }

  static Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  static Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  static Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  static Future<bool> isEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    
    try {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;
      return user?.emailVerified ?? false;
    } catch (e) {
      return user?.emailVerified ?? false;
    }
  }

  static Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();
      if (googleAccount == null) return null;

      final GoogleSignInAuthentication googleAuth = 
          await googleAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<UserCredential?> register(String email, String password) async {
    try {
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      print(error);
      return null;
    }
  }
}
