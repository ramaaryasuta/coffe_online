import 'package:flutter/material.dart';

import 'logo_app.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(
          width: 10,
        ),
        const LogoApp(),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Bergabung dengan Go-Coffe dan Cari Kopi Terdekat yang ada disekitarmu',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
