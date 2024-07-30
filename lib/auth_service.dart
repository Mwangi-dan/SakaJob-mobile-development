import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? _user;
  bool _isAuth = false;

  User? get user => _user;
  bool get isAuth => _isAuth;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      _isAuth = user != null;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection('users').doc(_user?.uid).set({
        'name': '',
        'username': '',
        'email': email,
        'bio': '',
        'profileImageUrl': '',
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<DocumentSnapshot> getUserProfile() async {
    return await _firestore.collection('users').doc(_user?.uid).get();
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(_user?.uid).update(data);
  }

  Future<String> uploadProfileImage(String filePath) async {
    File file = File(filePath);
    try {
      TaskSnapshot snapshot =
          await _storage.ref('profile_images/${_user?.uid}.jpg').putFile(file);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }
}
