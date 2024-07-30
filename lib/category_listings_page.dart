// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryListingsPage extends StatelessWidget {
  final String category;

  CategoryListingsPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Listings in $category'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var listings = snapshot.data!.docs;
          return ListView.builder(
            itemCount: listings.length,
            itemBuilder: (context, index) {
              var listing = listings[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(15),
                  leading: Image.network(
                    listing['imageUrl'],
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(listing['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listing['location']),
                      Text('KSh ${listing['salary']}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
