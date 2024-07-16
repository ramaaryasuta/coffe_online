import 'package:coffeonline/screens/home/widgets/button_order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/provider/order_service.dart';
import '../login/provider/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthService>();
    final orderProv = context.read<OrderService>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Center(
          child: MyButton(
              child:
                  const Text('Logout', style: TextStyle(color: Colors.white)),
              onPressed: () {
                orderProv.historyOrder.clear();
                authProv.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              }),
        )
        // Column(
        //   children: [
        //     ListTile(
        //       title: const Text('Edit Profile'),
        //       onTap: () {
        //         // Add your logic here
        //       },
        //     ),
        //     ListTile(
        //       title: const Text('Logout'),
        //       onTap: () {
        //         authProv.logout();
        //         Navigator.of(context).pushReplacementNamed('/login');
        //       },
        //     )
        //   ],
        // ),
        );
  }
}
