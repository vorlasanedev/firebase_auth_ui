import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth_ui/screens/auth/email_verify_screen.dart';
import 'package:firebase_auth_ui/screens/auth/login_screen.dart';
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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  // static Route<void> route() {
  //   return MaterialPageRoute(builder: (_) => SignupScreen());
  // }

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;

  // void _showError(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message), backgroundColor: Colors.red),
  //   );
  // }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          ); // Your actual signup function

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      if (!mounted) return; // Check if widget is still in widget tree
      ShowMessage().showSuccess(
        context,
        'Signup successful! Please verify your email.',
      );

      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text('Signup Successful')));
      // Navigate to home screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ShowMessage().showError(context, e.message ?? 'Register failed');
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
      appBar: AppBar(title: Text('Sign Up')),
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
              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _signUp,
                  child: _loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Sign Up'),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to Register screen
                  // Navigator.of(
                  //   context,
                  // ).pushAndRemoveUntil(LoginScreen.route(), (route) => false);
                  // or
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('I Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
