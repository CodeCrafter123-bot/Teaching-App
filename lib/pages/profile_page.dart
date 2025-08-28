import 'package:flutter/material.dart';
import 'package:teachingapp/services/auth_services.dart';
import 'package:teachingapp/services/database_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final dbHelper = DatabaseHelper();
  Map<String, dynamic>? user;

  late TextEditingController nameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    user = authService.currentUser;

    nameController = TextEditingController(text: user?['name'] ?? '');
    passwordController = TextEditingController();
  }

  void updateName() async {
    if (nameController.text.isNotEmpty && user != null) {
      await dbHelper.updateUser(user!['email'], newName: nameController.text);
      setState(() {
        user!['name'] = nameController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name updated successfully!")),
      );
    }
  }

  void updatePassword() async {
    if (passwordController.text.isNotEmpty && user != null) {
      await dbHelper.updateUser(user!['email'], newPassword: passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully!")),
      );
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: const Icon(Icons.person_outline, size: 50),
            ),
            const SizedBox(height: 16),
            Text(
              user!['email'],
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              "Joined: ${user!['joinedDate'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: updateName, child: const Text("Update Name")),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: updatePassword,
              child: const Text("Update Password"),
            ),
          ],
        ),
      ),
    );
  }
}
