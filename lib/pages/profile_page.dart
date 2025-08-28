import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../services/database_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController passwordController;
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    user = authService.currentUser;
    nameController = TextEditingController(text: user?['name'] ?? '');
    passwordController = TextEditingController();
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (user == null) return;

    await dbHelper.updateUser(
      user!['email'],
      newName: nameController.text.trim(),
      newPassword: passwordController.text.trim().isEmpty
          ? null
          : passwordController.text.trim(),
    );

    user = authService.currentUser;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                child: Text(user!['name'][0].toUpperCase()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Enter your name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "New Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveProfile,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
