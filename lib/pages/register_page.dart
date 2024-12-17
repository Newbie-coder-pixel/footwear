import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';
import 'login_page.dart'; // Assuming you have LoginPage for redirection after registration

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      assignId: true,
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: const Color(0xFF512DA8), // Deep Purple background
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Icon at the top
                  const Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white, // White background for the icon
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: Color(0xFF512DA8), // Deep Purple icon color
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Header Text
                  const Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White color for the header text
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fill in your details to register',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70, // Light white color for the subheading
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Register Card with Shadow and Border Radius
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Name Input
                        _buildTextField(
                          controller: ctrl.registerNameCtrl,
                          label: 'Your Name',
                          hint: 'Enter your full name',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),

                        // Email Input
                        _buildTextField(
                          controller: ctrl.registerEmailCtrl,
                          label: 'Email Address',
                          hint: 'Enter your email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        // Mobile Number Input
                        _buildTextField(
                          controller: ctrl.registerNumberCtrl,
                          label: 'Mobile Number',
                          hint: 'Enter your mobile number',
                          icon: Icons.phone_android,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),

                        // Password Input
                        _buildTextField(
                          controller: ctrl.registerPasswordCtrl,
                          label: 'Password',
                          hint: 'Enter your password',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),

                        // Register Button
                        ElevatedButton(
                          onPressed: () async {
                            // Call the register function and navigate on success
                            await ctrl.registerUser();
                            Get.off(() => const LoginPage()); // Navigate to LoginPage after success
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: const Color(0xFF512DA8), // Deep Purple button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Login Redirect
                        TextButton(
                          onPressed: () {
                            Get.to(const LoginPage()); // Navigate back to Login Page
                          },
                          child: const Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              color: Colors.deepPurple, // Deep Purple color for the link
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper function to build text fields
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
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF512DA8)),
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF512DA8)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
