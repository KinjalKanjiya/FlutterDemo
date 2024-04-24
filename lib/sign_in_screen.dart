import 'package:flutter/material.dart';
import 'api/google_sign_in_service.dart';
import 'home_screen.dart';

class SignInScreen extends StatelessWidget {
  final GoogleSignInService _googleSignInService;

  // Pass the GoogleSignInService instance as a parameter to the constructor
  SignInScreen({required GoogleSignInService googleSignInService})
      : _googleSignInService = googleSignInService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final account = await _googleSignInService.signIn();
            if (account != null) {
              final idToken = await _googleSignInService.getGoogleIdToken();
              print('Google ID Token: $idToken');
               Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(displayName: account.displayName ?? 'User'), // Pass the display name if available
                ),
              );
              // Navigate to the next screen or perform any other action
            } else {
              print('Sign-in failed.');
            }
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
