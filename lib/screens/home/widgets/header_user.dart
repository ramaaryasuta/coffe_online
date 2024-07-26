import 'package:coffeonline/screens/home/widgets/button_order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login/provider/auth_service.dart';
import '../provider/order_service.dart';

class HeaderUserAccount extends StatefulWidget {
  const HeaderUserAccount({
    super.key,
  });

  @override
  State<HeaderUserAccount> createState() => _HeaderUserAccountState();
}

class _HeaderUserAccountState extends State<HeaderUserAccount> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthService>();
    final orderProv = context.read<OrderService>();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
              'https://img.freepik.com/free-photo/fresh-coffee-steams-wooden-table-close-up-generative-ai_188544-8923.jpg'),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${provider.userData?.name ?? 'User'}!',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 5),
            if (provider.userData?.type == 'user') ...[
              Text('Mau Pesan apa hari ini?',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
            if (provider.userData?.type == 'merchant') ...[
              Text('Siap berjualan dengan semangat!',
                  style: Theme.of(context).textTheme.bodySmall),
            ]
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            showDialog(
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
                                Navigator.of(context)
                                    .pushReplacementNamed('/login');
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
          },
          icon: const Icon(Icons.logout),
        )
      ]),
    );
  }
}
