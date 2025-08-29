import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../services/database_helper.dart';
import '../widgets/primary_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;

  Map<String, dynamic>? user;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    user = authService.currentUser;
    nameController = TextEditingController(text: user?['name'] ?? '');
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (user == null) return;

    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (newPassword.isNotEmpty) {
      if (oldPassword != user!['password']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Old password is incorrect!")),
        );
        return;
      }
    }

    await dbHelper.updateUser(
      user!['email'],
      newName: nameController.text.trim(),
      newPassword: newPassword.isEmpty ? null : newPassword,
    );

    user = authService.currentUser;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );

    oldPasswordController.clear();
    newPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF6D83F2),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D83F2), Color(0xFF89CFF0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                elevation: 12,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF6D83F2),
                          child: Text(
                            user!['name'][0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 32, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? "Enter your name" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: oldPasswordController,
                          decoration: InputDecoration(
                            labelText: "Old Password",
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: newPasswordController,
                          decoration: InputDecoration(
                            labelText: "New Password",
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: "Save",
                          onPressed: saveProfile,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
