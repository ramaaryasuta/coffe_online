import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login/provider/auth_service.dart';
import '../provider/order_service.dart';
import '../widgets/button_order.dart';

class SettingSCreen extends StatefulWidget {
  const SettingSCreen({super.key});

  @override
  State<SettingSCreen> createState() => _SettingSCreenState();
}

class _SettingSCreenState extends State<SettingSCreen> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthService>();
    final orderProv = context.read<OrderService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Change Name'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Change Name'),
                    content: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          provider.changeName(
                              name: nameController.text, id: provider.userId!);
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              logoutDialog(context, orderProv, provider);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }

  Future<dynamic> logoutDialog(
      BuildContext context, OrderService orderProv, AuthService provider) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text('Apakah anda yakin ingin keluar?'),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 60.0),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Batal',
                          style: TextStyle(color: Colors.black),
                        )),
                    const SizedBox(width: 10.0),
                    MyButton(
                      child: const Text('Logout',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        orderProv.historyOrder.clear();
                        provider.logout();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
