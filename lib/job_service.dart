import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> get jobStream {
    return _firestore.collection('jobs').snapshots();
  }

  Future<void> addJob(Map<String, dynamic> jobData) async {
    try {
      await _firestore.collection('jobs').add(jobData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateJob(String jobId, Map<String, dynamic> jobData) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update(jobData);
    } catch (e) {
      rethrow;
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
