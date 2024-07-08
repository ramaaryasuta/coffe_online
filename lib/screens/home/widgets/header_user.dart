import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login/provider/auth_service.dart';

class HeaderUserAccount extends StatelessWidget {
  const HeaderUserAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthService>();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hallo, ${provider.userData?.name ?? 'User'}!',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 5),
              Text('Mau Ngopi Kapan nih?',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
          ),
        ],
      ),
    );
  }
}
