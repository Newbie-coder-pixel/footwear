import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  _UserAccountPageState createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;
  bool _isChanged = false; // Flag to track if data has been changed

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final box = GetStorage();

    // Load from GetStorage first
    _nameController.text = box.read('name') ?? '';
    _emailController.text = box.read('email') ?? '';
    _phoneController.text = (box.read('number')?.toString() ?? '');

    // Fetch from Firestore if the user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snapshot = await userRef.get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          _nameController.text = data['name'] ?? _nameController.text;
          _emailController.text = data['email'] ?? _emailController.text;
          _phoneController.text = (data['number']?.toString() ?? _phoneController.text);
        });
      }
    }
  }

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _isChanged = true; // Mark as changed
      });
    }
  }

  void _updateUserInfo() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final box = GetStorage();
      box.write('name', _nameController.text);
      box.write('email', _emailController.text);
      box.write('number', _phoneController.text);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        try {
          // Update Firestore with updated data
          await userRef.update({
            'name': _nameController.text,
            'email': _emailController.text,
            'number': _phoneController.text.isNotEmpty
                ? double.parse(_phoneController.text)
                : 0.0, // Parse to number
            if (_profileImage != null) 'profileImage': _profileImage!.path,
          });

          // Success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('User details updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Reset change flag
          setState(() {
            _isChanged = false;
          });
        } catch (e) {
          // Error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to update user details.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Account'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(Icons.account_circle, size: 50, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  _nameController,
                  'Name',
                  'Please enter your name',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  _emailController,
                  'Email',
                  'Please enter a valid email',
                  emailValidation: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  _phoneController,
                  'Phone',
                  'Please enter your phone number',
                  numericValidation: true,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _isChanged
                    ? ElevatedButton(
                  onPressed: _updateUserInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16),
                  ),
                )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String errorText, {
        bool emailValidation = false,
        bool numericValidation = false,
      }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 2, color: Colors.blueGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 2, color: Colors.blueGrey),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        if (emailValidation && !RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value)) {
          return 'Invalid email format';
        }
        if (numericValidation && !RegExp(r'^\d+\$').hasMatch(value)) {
          return 'Only numbers are allowed';
        }
        return null;
      },
      keyboardType: numericValidation ? TextInputType.number : TextInputType.text,
      onChanged: (_) {
        setState(() {
          _isChanged = true;
        });
      },
    );
  }
}
