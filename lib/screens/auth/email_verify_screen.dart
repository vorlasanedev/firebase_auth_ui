import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/screens/auth/login_screen.dart';
import 'package:firebase_auth_ui/screens/home_screen.dart';
import 'package:firebase_auth_ui/utils/show_message.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isEmailVerified = false;
  // bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerified();
  }

  Future<void> _checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // refresh user

    if (user != null && user.emailVerified) {
      setState(() {
        _isEmailVerified = true;
      });

      // If email is not verified, show verification page
      if (!_isEmailVerified) {
        // WidgetsBinding.instance.addPostFrameCallback((_) {});
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
          return;
        });
      }
    } else {
      // Show a message that email isn't verified yet
      // show snackbar message
      // if (!mounted) return;
      //     ShowMessage().showError(
      //   context,
      //   'Please verify your email before proceeding.',
      // );
      // show snackbar message

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowMessage().showError(
          context,
          'Please verify your email before proceeding.',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Your Email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A verification email has been sent to your email address.'),
            Text('Please check your inbox or Spam to verify email with link'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkEmailVerified,
              child: Text('I have verified my email'),
            ),
            SizedBox(height: 16),
            // if verified hide this button
            Text('No have email verify!'),
            ElevatedButton(
              onPressed: _isEmailVerified
                  ? null
                  : () async {
                      await FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();

                      // navigate after current frame to be extra-safe
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        ShowMessage().showSuccess(
                          context,
                          'Verification email resent',
                        );
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      });
                    },
              child: Text('Resend Email'),
            ),
          ],
        ),
      ),
    );
  }
}
