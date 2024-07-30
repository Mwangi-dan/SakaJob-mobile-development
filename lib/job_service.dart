import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> get jobStream {
    return _firestore.collection('jobs').snapshots();
  }

  Future<List<String>> getCategories() async {
    final snapshot = await _firestore.collection('jobs').get();
    final categories =
        snapshot.docs.map((doc) => doc['category'] as String).toSet().toList();
    return categories;
  }

  Future<void> addJob(Map<String, dynamic> jobData) async {
    try {
      await _firestore.collection('jobs').add(jobData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateJob(String jobId, Map<String, dynamic> jobData) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update(jobData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      await _firestore.collection('jobs').doc(jobId).delete();
    } catch (e) {
      throw e;
    }
  }
}
