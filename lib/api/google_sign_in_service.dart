// ignore_for_file: unused_import

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleSignInService {
  final String webClientId; // Google Web Client ID
  final String backendUrl; // Backend URL for sending the token

  late final GoogleSignIn _googleSignIn; // Google Sign-In instance

  GoogleSignInService(this.webClientId, this.backendUrl) {
    _googleSignIn = GoogleSignIn(clientId: webClientId); // Initialize Google Sign-In
  }

  // Function to sign in with Google
  Future<GoogleSignInAccount?> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn(); // Sign in
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        // print("Google ID Token: ${googleAuth.idToken}"); // Log the Google ID Token
        await verifyToken(googleAuth.idToken!); // Verify the token

        await sendTokenToBackend(googleAuth.idToken!); // Send token to backend
                
        // print("Google ID Token----------: ${googleAuth.idToken}"); // Log the Google ID Token
      }
      return googleUser;
    } catch (error) {
      // print('Error signing in with Google: $error'); // Handle sign-in error
      return null;
    }
  }

  // Function to sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  // Function to send Google ID Token to backend
  Future<void> sendTokenToBackend(String idToken) async {
    try {
      print('Sending token to backend: $idToken'); // Log token before sending
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'idToken': idToken,
        }),
      );
      print('Backend response: ${response.body}'); // Log backend response
      if (response.statusCode == 200) {
        print('Token sent to backend successfully');
        // You can verify the token here if needed
        await verifyToken(idToken);
      } else {
        print('Failed to send token to backend. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending token to backend: $error');
    }
  }

  // Function to verify Google ID Token
  Future<void> verifyToken(String idToken) async {
    try {
      final url = Uri.parse('https://oauth2.googleapis.com/tokeninfo?id_token=$idToken');
      // print("verify");
      // print("Test-----------$idToken");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Check if token is valid
        if (data['aud'] == webClientId) {
          // Token is valid, you can retrieve user information from data
          print('Token is valid');
          // print('User email: ${data['email']}');
          // Add other user information retrieval here
        } else {
          // Token is not valid for your application
          print('Invalid token');
        }
      } else {
        // Failed to verify token
        print('Failed to verify token');
      }
    } catch (error) {
      print('Error verifying token: $error');
    }
  }
 

  // Function to get Google ID Token
  Future<String?> getGoogleIdToken() async {
    try {
      final GoogleSignInAccount? account = _googleSignIn.currentUser;
      if (account != null) {
        final googleAuth = await account.authentication;
        return googleAuth.idToken;
      } else {
        print('No user signed in.');
      }
    } catch (error) {
      print('Error getting Google ID Token: $error');
    }
    return null;
  }

 Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return null;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          print('Location permissions are permanently denied, we cannot request permissions.');
          return null;
        }

        if (permission == LocationPermission.denied) {
          print('Location permissions are denied (actual value: $permission)');
          return null;
        }
      } 

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        print("Location : ---- $position");
        return position;
      }
    } catch (error) {
      print('Error getting current location: $error');
    }
    return null;
  }
}

