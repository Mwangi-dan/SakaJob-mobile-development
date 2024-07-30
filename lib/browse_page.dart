// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'category_listings_page.dart';
import 'job_service.dart';

class BrowsePage extends StatefulWidget {
  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentIndex = 1;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushNamed(context, '/');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/browse');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile');
    }
  }

  Future<void> _loadCategories() async {
    final jobService = Provider.of<JobService>(context, listen: false);
    _categories = await jobService.getCategories();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with your logo asset path
              height: 30,
            ),
            SizedBox(width: 10),
            Text('SAKAJOB'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Replace with your logo asset path
                    height: 50,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
              onTap: () {
                Navigator.pushNamed(context, '/browse');
              },
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('View applications'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/coming-soon',
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            SizedBox(height: 20), // Use SizedBox to provide space
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('FOLLOW US'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, color: Colors.pink, size: 30),
                      SizedBox(width: 10),
                      Icon(Icons.circle, color: Colors.pink, size: 30),
                      SizedBox(width: 10),
                      Icon(Icons.circle, color: Colors.pink, size: 30),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: _updateSearchQuery,
            ),
            SizedBox(height: 20),
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 150,
              child: _categories.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return _buildCategoryCard(context, _categories[index]);
                      },
                    ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Listings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                  child: Text(
                    'MORE',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('jobs')
                    .orderBy('dateposted', descending: true)
                    .limit(7) // Limit to 7 most recent listings
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var listings = snapshot.data!.docs.where((doc) {
                    var title = doc['title'] as String;
                    return title
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase());
                  }).toList();
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      var listing = listings[index];
                      return _buildTopListingCard(
                        listing['title'],
                        listing['location'],
                        listing['imageUrl'], // Pass imageUrl to the function
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryListingsPage(category: category),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png', // Replace with your category image asset path
                height: 80,
              ),
              SizedBox(height: 10),
              Text(category),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopListingCard(String title, String location, String imageUrl) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl, // Display the image from the URL
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(location),
          ],
        ),
      ),
    );
  }
}
