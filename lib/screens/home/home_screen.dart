import 'package:flutter/material.dart';

import 'widgets/button_order.dart';
import 'widgets/header_user.dart';
import 'widgets/menu_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          HeaderUserAccount(),
          MenuContainer(),
          Spacer(),
          OrderButton(),
        ],
      ),
    );
  }
}
