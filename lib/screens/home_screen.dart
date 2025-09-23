import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/screens/auth/login_screen.dart';
import 'package:firebase_auth_ui/utils/show_message.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              WidgetsBinding.instance.addPostFrameCallback((_) {
                // if (!mounted) return;
                ShowMessage().showSuccess(context, 'Logout Successful');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to Home Screen!', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
