import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login/provider/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Edit Profile'),
            onTap: () {
              // Add your logic here
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              authProv.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          )
        ],
      ),
    );
  }
}
