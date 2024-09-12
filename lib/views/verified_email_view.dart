import 'package:flutter/material.dart';
import 'package:disabilapp/constants/routes.dart';
import 'package:disabilapp/servicies/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  late Future<void> _verificationFuture;
  String _feedbackMessage = '';

  Future<void> _signOut() async {
    try {
      await AuthService.firebase().logOut();
      Navigator.of(context).pushNamedAndRemoveUntil(
        registerRoute,
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _feedbackMessage = 'An error occurred while signing out.';
      });
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      await AuthService.firebase().sendEmailVerification();
      setState(() {
        _feedbackMessage = 'Verification email has been sent!';
      });
    } catch (e) {
      setState(() {
        _feedbackMessage =
            'An error occurred while sending verification email.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _verificationFuture = _sendVerificationEmail();
  }

  Widget _buildFeedbackMessage() {
    return Text(
      _feedbackMessage,
      style: TextStyle(
        color: _feedbackMessage.contains('error') ? Colors.red : Colors.green,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "We've sent you an email verification. Please open it to verify your account.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "If you haven't received the email yet, please click the button below to resend it.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FutureBuilder<void>(
                future: _verificationFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _verificationFuture = _sendVerificationEmail();
                        });
                      },
                      child: const Text('Resend Verification Email'),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildFeedbackMessage(),
              TextButton(
                  child: const Text('Restart'),
                  onPressed: () async {
                    await _signOut();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
