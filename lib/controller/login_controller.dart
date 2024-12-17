import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart'; // Import login page for redirection

class LoginController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GetStorage box = GetStorage();

  late CollectionReference userCollection;

  // Controllers for Registration
  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registerNumberCtrl = TextEditingController();
  TextEditingController registerEmailCtrl = TextEditingController();
  TextEditingController registerPasswordCtrl = TextEditingController();

  // Controllers for Login
  TextEditingController loginEmailCtrl = TextEditingController();
  TextEditingController loginPasswordCtrl = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    userCollection = firestore.collection('users');
    super.onInit();
  }

  // Fungsi Registrasi
  Future<void> registerUser() async {
    try {
      isLoading.value = true;

      // Validasi input
      if (registerNameCtrl.text.isEmpty ||
          registerNumberCtrl.text.isEmpty ||
          registerEmailCtrl.text.isEmpty ||
          registerPasswordCtrl.text.isEmpty) {
        Get.snackbar('Error', 'Please fill in all fields', colorText: Colors.red);
        return;
      }

      // Validasi nomor telepon
      if (!_isValidPhone(registerNumberCtrl.text)) {
        Get.snackbar('Error', 'Invalid phone number format', colorText: Colors.red);
        return;
      }

      // Daftarkan user ke Firebase Auth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: registerEmailCtrl.text,
        password: registerPasswordCtrl.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Simpan data tambahan ke Firestore
        await userCollection.doc(user.uid).set({
          'name': registerNameCtrl.text,
          'number': int.parse(registerNumberCtrl.text), // Simpan nomor sebagai int
          'email': registerEmailCtrl.text,
        });

        // Success message
        Get.snackbar('Success', 'Registration successful', colorText: Colors.green);

        // Clear fields
        registerNameCtrl.clear();
        registerNumberCtrl.clear();
        registerEmailCtrl.clear();
        registerPasswordCtrl.clear();

        // Redirect to LoginPage
        Get.off(() => const LoginPage());  // Redirect to the login page
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred', colorText: Colors.red);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred', colorText: Colors.red);
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi Login
  Future<void> loginUser() async {
    try {
      isLoading.value = true;

      // Validasi input
      if (loginEmailCtrl.text.isEmpty || loginPasswordCtrl.text.isEmpty) {
        Get.snackbar('Error', 'Please fill in all fields', colorText: Colors.red);
        return;
      }

      // Login menggunakan Firebase Auth
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: loginEmailCtrl.text,
        password: loginPasswordCtrl.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Ambil data user dari Firestore
        DocumentSnapshot userDoc = await userCollection.doc(user.uid).get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;

          // Simpan data ke GetStorage
          box.write('user', {
            'name': userData['name'],
            'number': userData['number'],
            'email': userData['email'],
          });

          Get.snackbar('Success', 'Login successful', colorText: Colors.green);
          Get.off(() => const HomePage()); // Redirect to HomePage on success
        } else {
          Get.snackbar('Error', 'User data not found in Firestore', colorText: Colors.red);
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred', colorText: Colors.red);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred', colorText: Colors.red);
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Social Login: Google
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        // Ambil data user dari Firestore
        DocumentSnapshot userDoc = await userCollection.doc(user.uid).get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;

          // Simpan data ke GetStorage
          box.write('user', {
            'name': userData['name'],
            'number': userData['number'],
            'email': userData['email'],
          });

          Get.snackbar('Success', 'Google login successful', colorText: Colors.green);
          Get.off(() => const HomePage()); // Redirect to HomePage on success
        } else {
          Get.snackbar('Error', 'User data not found in Firestore', colorText: Colors.red);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Google login failed', colorText: Colors.red);
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Social Login: Facebook
  Future<void> loginWithFacebook() async {
    try {
      isLoading.value = true;

      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.token);
        final UserCredential userCredential = await auth.signInWithCredential(facebookCredential);
        User? user = userCredential.user;
        if (user != null) {
          // Ambil data user dari Firestore
          DocumentSnapshot userDoc = await userCollection.doc(user.uid).get();

          if (userDoc.exists) {
            var userData = userDoc.data() as Map<String, dynamic>;

            // Simpan data ke GetStorage
            box.write('user', {
              'name': userData['name'],
              'number': userData['number'],
              'email': userData['email'],
            });

            Get.snackbar('Success', 'Facebook login successful', colorText: Colors.green);
            Get.off(() => const HomePage()); // Redirect to HomePage on success
          } else {
            Get.snackbar('Error', 'User data not found in Firestore', colorText: Colors.red);
          }
        }
      } else {
        Get.snackbar('Error', 'Facebook login failed', colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Facebook login failed', colorText: Colors.red);
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Social Login: Apple
  Future<void> loginWithApple() async {
    try {
      isLoading.value = true;

      final AuthorizationCredentialAppleID appleIDCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScope.email,
          AppleIDAuthorizationScope.fullName,
        ],
      );

      final AuthCredential appleCredential = OAuthProvider("apple.com").credential(
        idToken: appleIDCredential.idToken,
        accessToken: appleIDCredential.authorizationCode,
      );

      final UserCredential userCredential = await auth.signInWithCredential(appleCredential);
      User? user = userCredential.user;
      if (user != null) {
        // Ambil data user dari Firestore
        DocumentSnapshot userDoc = await userCollection.doc(user.uid).get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;

          // Simpan data ke GetStorage
          box.write('user', {
            'name': userData['name'],
            'number': userData['number'],
            'email': userData['email'],
          });

          Get.snackbar('Success', 'Apple login successful', colorText: Colors.green);
          Get.off(() => const HomePage()); // Redirect to HomePage on success
        } else {
          Get.snackbar('Error', 'User data not found in Firestore', colorText: Colors.red);
        }
      }
    } catch (e)      {
      Get.snackbar('Error', 'Apple login failed', colorText: Colors.red);
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Validasi nomor telepon
  bool _isValidPhone(String phone) {
    final RegExp phoneRegExp = RegExp(r'^[0-9]{10,13}$');
    return phoneRegExp.hasMatch(phone);
  }
}

extension on AuthorizationCredentialAppleID {
  get idToken => null;
}

class AppleIDAuthorizationScope {
  static var email;

  static var fullName;
}

extension on AccessToken {
  String get token => 'String';
}
