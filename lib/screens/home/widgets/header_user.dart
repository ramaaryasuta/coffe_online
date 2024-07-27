import 'package:coffeonline/screens/home/subview/setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login/provider/auth_service.dart';

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
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return SettingSCreen();
              },
            ));
          },
          icon: const Icon(Icons.settings),
        )
      ]),
    );
  }
}
