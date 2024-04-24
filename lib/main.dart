import 'package:flutter/material.dart';
import 'sign_in_screen.dart';
import 'api/google_sign_in_service.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final String webClientId = '264994690136-4t5u4r9bbu0s680gscbr8r1dsbj0mlku.apps.googleusercontent.com';
final String backendUrl = "http://192.168.1.10:5000/verify-token";
  @override
  Widget build(BuildContext context) {
final GoogleSignInService _googleSignInService = GoogleSignInService(webClientId, backendUrl);

    return MaterialApp(
      title: 'Google Sign-In Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(googleSignInService: _googleSignInService),
    );
  }
}

