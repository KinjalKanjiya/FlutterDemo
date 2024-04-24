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

        await sendTokenToBackend(googleAuth.idToken!); // Non-null assertion here
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
      final response = await http.post(
        Uri.parse(backendUrl),
        body: {'idToken': idToken},
      );
      if (response.statusCode == 200) {
        print('Token sent to backend successfully');
      } else {
        print('Failed to send token to backend. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending token to backend: $error');
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
