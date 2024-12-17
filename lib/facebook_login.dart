import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> loginWithFacebook() async {
    try {
      // Trigger the Facebook login flow
      final LoginResult result = await FacebookAuth.instance.login();

      // Check if the login was successful
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // Create a Facebook credential
        final AuthCredential facebookCredential = FacebookAuthProvider.credential(accessToken.token);

        // Sign in with the credential
        final UserCredential userCredential = await auth.signInWithCredential(facebookCredential);
        return userCredential.user;
      } else {
        throw Exception('Facebook login failed');
      }
    } catch (e) {
      throw Exception('Error during Facebook login: $e');
    }
  }
}

extension on AccessToken {
  String get token => 'String';
}
