import 'package:flutter/material.dart';

import 'widgets/button_order.dart';
import 'widgets/header_user.dart';
import 'widgets/main_search_coffe.dart';
import 'widgets/menu_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderUserAccount(),
            MenuContainer(),
            SearchCoffe(),
            OrderButton(),
          ],
        ),
      ),
    );
  }
}
