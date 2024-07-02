import 'package:flutter/material.dart';

import 'widgets/background_decor.dart';
import 'widgets/login_form.dart';
import 'widgets/logo_app.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundDecor(
              top: -80,
              right: -100,
            ),
            BackgroundDecor(
              bottom: -100,
              left: -80,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LogoApp(),
                  SizedBox(height: 20),
                  LoginForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
