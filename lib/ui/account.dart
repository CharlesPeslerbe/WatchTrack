import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatefulWidget {
  final String title;

  const AccountPage({Key? key, required this.title}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Future<void> _deleteAccount() async {
    try {
      await _user!.delete();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      // Display user's profile photo
      CircleAvatar(
      radius: 50,
      backgroundImage: _user != null && _user!.photoURL != null
          ? NetworkImage(_user!.photoURL!)
          : AssetImage('assets/default_profile.png') as ImageProvider,
    ),
    SizedBox(height: 16),
    // Display user's display name
    Text(
    _user != null ? _user!.displayName ?? 'Username' : 'Username',
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 8),
    // Display user statistics (you may replace dummy values with actual user data)
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    // Number of followed series
    _buildStatistic('123', 'Series'),
    SizedBox(width: 16),
    // Number of episodes watched
    _buildStatistic('456', 'Episodes'),
    SizedBox(width: 16),
    // Number of days spent watching series
    _buildStatistic('789', 'Days'),
    ],
    ),
    SizedBox(height: 16),
    // Social media login buttons
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    IconButton(
    icon: Icon(Icons.facebook),
    color: Colors.blue,
    onPressed: () {},
    ),
    SizedBox(width: 16),
    IconButton(
    icon: Icon(Icons.add_box),
    color: Colors.grey,
    onPressed: () {},
    ),
    SizedBox(width: 16),
    IconButton(
    icon: Icon(Icons.add_box),
    color: Colors.pink,
    onPressed: () {},
    ),
    ],
    ),
    SizedBox(height: 16),
    // Fancy logout button
    ElevatedButton(
    onPressed: _signOut,
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    shadowColor: Colors.redAccent,
    elevation: 5,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0)),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    ),
      child: Text(
        'Logout',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
        SizedBox(height: 16),
        // Delete account button
        ElevatedButton(
          onPressed: _user != null ? _deleteAccount : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shadowColor: Colors.redAccent,
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: Text(
            'Delete Account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      ),
      ),
    );
  }

  // Helper method to build statistics widget
  Widget _buildStatistic(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
