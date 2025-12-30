import 'package:flutter/material.dart';
import 'package:anime_store/services/auth_service.dart';
import 'package:anime_store/pages/login_page.dart';
import 'package:anime_store/pages/home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _fName = TextEditingController();
  final _lName = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _age = TextEditingController();
  String _gender = 'Male';

  void _submit() async {
    // Check only required fields; Age is optional
    if (_fName.text.trim().isEmpty ||
        _lName.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _pass.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    final result = await AuthService().signup({
      'firstName': _fName.text.trim(),
      'lastName': _lName.text.trim(),
      'email': _email.text.trim(),
      'password': _pass.text,
      // age is null if the field is empty
      'age': _age.text.trim().isEmpty ? null : int.tryParse(_age.text),
      'gender': _gender,
    });

    if (result == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (c) => const HomePage()),
              (r) => false
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _fName, decoration: const InputDecoration(labelText: "First Name")),
            TextField(controller: _lName, decoration: const InputDecoration(labelText: "Last Name")),
            TextField(controller: _age, decoration: const InputDecoration(labelText: "Age (Optional)"), keyboardType: TextInputType.number),
            TextField(controller: _email, decoration: const InputDecoration(labelText: "Email"), keyboardType: TextInputType.emailAddress),
            TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Gender: "),
                DropdownButton<String>(
                  value: _gender,
                  items: ['Male', 'Female'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (v) => setState(() => _gender = v!),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _submit, child: const Text("Create Account")),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginPage())),
              child: const Text("Already have account? log in"),
            )
          ],
        ),
      ),
    );
  }
}