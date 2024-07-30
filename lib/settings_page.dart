import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 30,
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('General'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: Text('Allow Notifications'),
                  value: true,
                  onChanged: (bool value) {
                    Navigator.pushNamed(context, '/coming-soon');
                  },
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('About'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Privacy policy'),
                  onTap: () {
                    Navigator.pushNamed(context, '/coming-soon');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.link),
                  title: Text('Visit www.ui-kit.co'),
                  onTap: () {
                    // Handle navigation to website
                  },
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Clear cache'),
            onTap: () {
              Navigator.pushNamed(context, '/coming-soon');
            },
          ),
        ],
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
