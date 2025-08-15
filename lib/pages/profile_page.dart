
import 'package:flutter/material.dart';
import 'package:teachingapp/services/auth_services.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person_outline)),
              title: Text(user?.name ?? 'Guest'),
              subtitle: Text(user?.email ?? 'guest@example.com'),
            ),
            const SizedBox(height: 12),
            const Text('Settings', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SwitchListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('Dark Mode (visual only)'),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              subtitle: const Text('How we handle your data (demo).'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
