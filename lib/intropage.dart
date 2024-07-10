import 'package:coffeonline/screens/home/widgets/button_order.dart';
import 'package:coffeonline/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/login/provider/auth_service.dart';
import 'utils/print_log.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthService>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SELAMAT DATANG DI\n GO-COFFE',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            MyButton(
              child: Text(
                'KUY NGOPI',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
              onPressed: () {
                setDataUser().then(
                  (value) {
                    if (authProv.token.isNotEmpty ||
                        authProv.userData != null) {
                      Navigator.pushReplacementNamed(context, '/');
                    } else {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setDataUser() async {
    final authProv = context.read<AuthService>();
    LoadingDialog.show(context, message: 'Mendapatkan data user');
    try {
      printLog('udah ngeget');
      await authProv.getUserData(
        authProv.userId!,
      );
      printLog('berhasil ${authProv.userData!.type}');
    } catch (e) {
      printLog(e);
    }
    LoadingDialog.hide(context);
  }
}
