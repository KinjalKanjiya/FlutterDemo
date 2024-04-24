import 'package:flutter/material.dart';
import 'api/google_sign_in_service.dart';
import 'sign_in_screen.dart';
class HomeScreen extends StatelessWidget {
  final String displayName;

  HomeScreen({required this.displayName});

  @override
  Widget build(BuildContext context) {
    final String webClientId = '264994690136-4t5u4r9bbu0s680gscbr8r1dsbj0mlku.apps.googleusercontent.com';
    final String backendUrl = 'http://192.168.1.10:5000/verify-token';

final GoogleSignInService googleSignInService = GoogleSignInService(webClientId, backendUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $displayName'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User details here'), // Display user details here
          ElevatedButton(
              onPressed: () async {
                await googleSignInService.signOut(); // Sign out the user
                Navigator.pushReplacement( // Navigate back to sign-in screen
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(googleSignInService: googleSignInService),
                  ),
                );
              },
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
