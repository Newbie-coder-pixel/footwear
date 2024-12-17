import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:footwear_client/pages/register_page.dart';

import '../controller/login_controller.dart';
import '../pages/home_page.dart'; // Import home page for redirection

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      assignId: true,
      builder: (ctrl) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6A1B9A),
                  Color(0xFF8E24AA),
                  Color(0xFFCE93D8),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: Color(0xFF6A1B9A)),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Login to your account to continue',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 40),
                    _buildLoginCard(ctrl),
                    const SizedBox(height: 20),
                    _buildSocialLoginButtons(ctrl),  // Social login buttons
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Get.to(const RegisterPage()),
                      child: const Text(
                        'Don’t have an account? Register Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginCard(LoginController ctrl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildTextField(
            controller: ctrl.loginEmailCtrl,
            label: 'Email Address',
            hint: 'Enter your email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: ctrl.loginPasswordCtrl,
            label: 'Password',
            hint: 'Enter your password',
            icon: Icons.lock,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.loginEmailCtrl.text.isEmpty || ctrl.loginPasswordCtrl.text.isEmpty) {
                Get.snackbar('Error', 'Please fill all fields',
                    colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
                return;
              }
              await ctrl.loginUser(); // Using the loginUser method from the controller
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color(0xFF6A1B9A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF6A1B9A)),
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF6A1B9A), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButtons(LoginController ctrl) {
    return Column(
      children: [
        // Google Login
        ElevatedButton.icon(
          onPressed: () async => await ctrl.loginWithGoogle(),
          icon: const Icon(Icons.g_mobiledata),
          label: const Text('Login with Google'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 15),

        // Facebook Login
        ElevatedButton.icon(
          onPressed: () async => await ctrl.loginWithFacebook(),
          icon: const Icon(Icons.facebook),
          label: const Text('Login with Facebook'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 15),

        // Apple Login
        ElevatedButton.icon(
          onPressed: () async => await ctrl.loginWithApple(),
          icon: const Icon(Icons.apple),
          label: const Text('Login with Apple'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
