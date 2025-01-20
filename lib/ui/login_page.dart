import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails {
  // Global constants for user details
  static late String name;
  static late String email;
  static late String phone;
  static late String profession;
  static late String purpose;

  static Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    email = prefs.getString('email') ?? '';
    phone = prefs.getString('phone') ?? '';
    profession = prefs.getString('profession') ?? '';
    purpose = prefs.getString('purpose') ?? '';
  }

  static Future<void> saveUserDetails({
    required String name,
    required String email,
    required String phone,
    required String profession,
    required String purpose,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('profession', profession);
    await prefs.setString('purpose', purpose);
  }
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  Future<void> _submitForm() async {
    // Save user details to persistent storage
    await UserDetails.saveUserDetails(
      name: _nameController.text,
      email: _emailController.text,
      phone: _nameController.text,
      profession: _professionController.text,
      purpose: _purposeController.text,
    );

    // Load the saved user details into memory
    await UserDetails.loadUserDetails();

    // Navigate to the home page
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email ID'),
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: _professionController,
                decoration: const InputDecoration(labelText: 'Profession'),
              ),
              TextField(
                controller: _purposeController,
                decoration: const InputDecoration(labelText: 'Purpose'),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
