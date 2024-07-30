// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'auth_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  String _profileImageUrl = '';
  bool _isLoading = true;
  int _currentIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushNamed(context, '/dashboard');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/browse');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _bioController = TextEditingController();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    var authService = Provider.of<AuthService>(context, listen: false);
    DocumentSnapshot userProfile = await authService.getUserProfile();
    setState(() {
      _nameController.text = userProfile['name'] ?? '';
      _usernameController.text = userProfile['username'] ?? '';
      _emailController.text = userProfile['email'] ?? '';
      _bioController.text = userProfile['bio'] ?? '';
      _profileImageUrl =
          userProfile['profileImageUrl'] ?? 'assets/images/profile.png';
      _isLoading = false;
    });
  }

  Future<void> _updateUserProfile() async {
    var authService = Provider.of<AuthService>(context, listen: false);
    await authService.updateUserProfile({
      'name': _nameController.text,
      'username': _usernameController.text,
      'email': _emailController.text,
      'bio': _bioController.text,
      'profileImageUrl': _profileImageUrl,
    });
    _fetchUserProfile();
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var authService = Provider.of<AuthService>(context, listen: false);
      String downloadUrl =
          await authService.uploadProfileImage(pickedFile.path);
      setState(() {
        _profileImageUrl = downloadUrl;
      });
      _updateUserProfile();
    }
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
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImageUrl.isNotEmpty
                            ? NetworkImage(_profileImageUrl)
                                as ImageProvider<Object>?
                            : AssetImage('assets/images/profile.png'),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: _pickProfileImage,
                        child: Text('Edit profile image',
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text('Name'),
                  subtitle: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Name',
                    ),
                  ),
                  trailing: Icon(Icons.edit),
                ),
                Divider(),
                ListTile(
                  title: Text('Username'),
                  subtitle: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                    ),
                  ),
                  trailing: Icon(Icons.edit),
                ),
                Divider(),
                ListTile(
                  title: Text('Email'),
                  subtitle: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                  ),
                  trailing: Icon(Icons.edit),
                ),
                Divider(),
                ListTile(
                  title: Text('Bio'),
                  subtitle: TextField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Bio',
                    ),
                  ),
                  trailing: Icon(Icons.edit),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    ),
                    onPressed: () async {
                      await Provider.of<AuthService>(context, listen: false)
                          .signOut();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text(
                      'LOGOUT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    ),
                    onPressed: _updateUserProfile,
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
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
