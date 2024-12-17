import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'controller/login_controller.dart';

class AppleLoginService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> loginWithApple() async {
    try {
      // Request the Apple ID credential
      final AuthorizationCredentialAppleID appleIDCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScope.email, AppleIDAuthorizationScope.fullName],
      );

      // Create an Apple credential with the idToken and authorizationCode
      final AuthCredential appleCredential = OAuthProvider("apple.com").credential(
        idToken: appleIDCredential.idToken!,
        accessToken: appleIDCredential.authorizationCode!,
      );

      // Sign in with the credential
      final UserCredential userCredential = await auth.signInWithCredential(appleCredential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Error during Apple login: $e');
    }
  }
}

extension on AuthorizationCredentialAppleID {
  get idToken => null;
}
