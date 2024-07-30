// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'job_service.dart';
import 'search_service.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;
  String _selectedCategory = 'All';
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _updateSearchQuery(String query) {
    setState(() {});
    Provider.of<SearchService>(context, listen: false).addSearchQuery(query);
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

  void _applyCategoryFilter(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  Future<void> _loadCategories() async {
    final jobService = Provider.of<JobService>(context, listen: false);
    _categories = await jobService.getCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final jobService = Provider.of<JobService>(context);

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
                Navigator.pushNamed(context, '/coming-soon');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            SizedBox(height: 20),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: Icon(Icons.filter_list),
                  label: Text('Filters'),
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ListView(
                          children: [
                            ListTile(
                              title: Text('All'),
                              onTap: () {
                                _applyCategoryFilter('All');
                                Navigator.pop(context);
                              },
                            ),
                            ..._categories.map((category) {
                              return ListTile(
                                title: Text(category),
                                onTap: () {
                                  _applyCategoryFilter(category);
                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: jobService.jobStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  final jobs = snapshot.data?.docs.where((doc) {
                        final category = doc['category'] as String;
                        return _selectedCategory == 'All' ||
                            category == _selectedCategory;
                      }).toList() ??
                      [];

                  if (jobs.isEmpty) {
                    return Center(child: Text('No jobs available'));
                  }

                  return ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      var job = jobs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/job-details',
                            arguments: {
                              'title': job['title'],
                              'description': job['description'],
                              'experience': job['experience'],
                              'employment': job['employment'],
                              'salary': job['salary'],
                              'imageUrl': job['imageUrl'],
                              'location': job['location'],
                              'dateposted': job['dateposted'],
                            },
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(15),
                            leading: job['imageUrl'] != null
                                ? Image.network(
                                    job['imageUrl'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.image, size: 50),
                            title: Text(job['title']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('KSh ${job['salary']}'),
                                Text(job['employment']),
                                Text(job['location']),
                                Text(job['dateposted']),
                              ],
                            ),
                          ),
                        ),
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
}
