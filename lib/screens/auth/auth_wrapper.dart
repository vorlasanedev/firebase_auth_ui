import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/screens/auth/email_verify_screen.dart';
import 'package:firebase_auth_ui/screens/auth/login_screen.dart';
import 'package:firebase_auth_ui/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? user;
  bool _isEmailVerified = false;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    setState(() => _checking = true);
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Reload user to get latest info
      await user!.reload();
      user = FirebaseAuth.instance.currentUser;

      // Optionally, check email verification
      _isEmailVerified = user?.emailVerified ?? false;

      if (!mounted) return; // guard against disposed State
      // If email is not verified, show verification page
      if (!_isEmailVerified) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => EmailVerificationScreen()),
        );
        return;
      }
    }
    setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      // Not logged in or email not verified, show login screen
      return LoginScreen();
    } else if (!_isEmailVerified) {
      return EmailVerificationScreen();
    } else {
      // User logged in and email verified
      return HomeScreen();
    }
  }
}
