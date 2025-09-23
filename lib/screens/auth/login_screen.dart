import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/screens/auth/email_verify_screen.dart';
import 'package:firebase_auth_ui/screens/auth/forgot_password_screen.dart';
import 'package:firebase_auth_ui/screens/auth/signup_screen.dart';
import 'package:firebase_auth_ui/screens/home_screen.dart';
import 'package:firebase_auth_ui/utils/show_message.dart';
import 'package:flutter/material.dart';

// Mock functions to simulate sign-up logic
// Replace these with your actual Firebase/Supabase logic.
Future<void> signUp(String email, String password) async {
  // Simulate a delay
  await Future.delayed(Duration(seconds: 2));
  // Throw an error for testing
  // throw Exception("Email already exists");
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  // for route page text button
  // static Route<void> route() {
  //   return MaterialPageRoute(builder: (_) => LoginScreen());
  // }
  // for route page

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Reload user info to get updated emailVerified status
      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        // Email verified, proceed
        // if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          ShowMessage().showSuccess(context, 'Login Successful');
        });
      } else {
        // if (!mounted) return; // guard against disposed State
        // Email not verified
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      // print('FirebaseAuthException: ${e.code}, ${e.message}');
      String message;
      if (e.code == 'invalid-credential') {
        message = 'Invalid or expired credential. Please try again.';
      } else {
        switch (e.code) {
          case 'wrong-password':
            message = 'Incorrect password.';
            break;
          case 'user-not-found':
            message = 'No account found with this email.';
            break;
          case 'invalid-email':
            message = 'Email address is not valid.';
            break;
          default:
            message = 'Login failed. Please try again.';
        }
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowMessage().showError(context, message);
      });
    } catch (e) {
      // print('Exception: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowMessage().showError(context, 'An unexpected error occurred');
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email TextField
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Password TextField
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Password is required';
                  }
                  if (value.trim().length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Text('Forgot Password?'),
              ),

              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to Register screen
                  // Navigator.of(
                  //   context,
                  // ).pushAndRemoveUntil(SignupScreen.route(), (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
