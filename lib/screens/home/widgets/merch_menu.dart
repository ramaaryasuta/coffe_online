import 'package:coffeonline/screens/login/provider/auth_service.dart';
import 'package:coffeonline/utils/print_log.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order_service.dart';

class MerchMenu extends StatefulWidget {
  const MerchMenu({
    super.key,
  });

  @override
  State<MerchMenu> createState() => _MerchMenuState();
}

class _MerchMenuState extends State<MerchMenu> {
  @override
  Widget build(BuildContext context) {
    final _authService = context.read<AuthService>();
    final _orderService = context.read<OrderService>();
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              _orderService.getOrderByMerchant(
                token: _authService.token,
                merchantId: _authService.userData!.merchId,
              );
            },
            child: Text('Test fetch history'),
          ),
        ),
        Container(
          width: double.infinity,
          height: 400,
          child: ListView.builder(
            itemCount: _orderService.historyOrder.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_orderService.historyOrder[index].id.toString()),
                subtitle: Text(_orderService.historyOrder[index].status),
              );
            },
          ),
        )
      ],
    );
  }
}
