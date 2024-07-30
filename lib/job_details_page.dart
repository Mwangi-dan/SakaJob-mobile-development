import 'package:flutter/material.dart';

class JobDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> job =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            job['imageUrl'] != null
                ? Image.network(
                    job['imageUrl'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Center(
                      child:
                          Icon(Icons.image, size: 100, color: Colors.grey[600]),
                    ),
                  ),
            SizedBox(height: 10),
            Text('1 day ago', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 5),
            Text(job['title'] ?? 'Job Title',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(job['description'] ?? 'Job Description',
                style: TextStyle(fontSize: 16)),
            Divider(height: 30, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Experience',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(job['experience'] ?? 'Experience'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Employment',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(job['employment'] ?? 'Employment Type'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Salary', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(job['salary'] ?? 'Salary'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/coming-soon');
              },
              child: Center(
                child: Text('Apply Now',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
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
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/dashboard');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/browse');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
