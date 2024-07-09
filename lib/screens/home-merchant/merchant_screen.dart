import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/print_log.dart';
import '../../utils/socket/socket_service.dart';
import '../login/provider/auth_service.dart';

class MerchantScreen extends StatefulWidget {
  const MerchantScreen({super.key});

  @override
  State<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<AuthService>(context, listen: true);
    // final orderProv = Provider.of<OrderService>(context, listen: true);
    final socketService = Provider.of<SocketServices>(context, listen: true);
    socketService.socket.connect();
    socketService.socket.on('${userProv.userId}-request-order', (data) {
      printLog('Socket mencari penjual...');
      printLog(data);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mode Merchant',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Container(),
    );
  }
}
