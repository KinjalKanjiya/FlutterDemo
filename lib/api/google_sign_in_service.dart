import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final String webClientId;
  final String backendUrl;

  late final GoogleSignIn _googleSignIn;

  GoogleSignInService(this.webClientId, this.backendUrl) {
    _googleSignIn = GoogleSignIn(clientId: webClientId);
  }

  Future<GoogleSignInAccount?> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        print("Google ID Token: ${googleAuth.idToken}");
         await verifyToken(googleAuth.idToken!);
        await sendTokenToBackend(googleAuth.idToken!); // Non-null assertion here
        print("Google ID Token----------: ${googleAuth.idToken}");

      }
      return googleUser;
    } catch (error) {
      print('Error signing in with Google: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<void> sendTokenToBackend(String idToken) async {
  try {
    print('Sending token to backend: $idToken');
    final response = await http.post(
      Uri.parse(backendUrl),
      body: {'idToken': idToken},
    );
    print('Backend response: ${response.body}');
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

 Future<void> verifyToken(String idToken) async {
    try {
      final url = Uri.parse('https://oauth2.googleapis.com/tokeninfo?id_token=$idToken');
      print("verify");
      print("Test-----------$idToken");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Check if token is valid
        if (data['aud'] == webClientId) {
          // Token is valid, you can retrieve user information from data
          print('Token is valid');
          print('User email: ${data['email']}');
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
}
