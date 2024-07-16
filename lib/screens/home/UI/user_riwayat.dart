import 'package:coffeonline/screens/home/widgets/button_order.dart';
import 'package:coffeonline/screens/orders/waiting_accept.dart';
import 'package:coffeonline/utils/date_convert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login/provider/auth_service.dart';
import '../provider/order_service.dart';

class UserHistoryScreen extends StatefulWidget {
  const UserHistoryScreen({super.key});

  @override
  State<UserHistoryScreen> createState() => _UserHistoryScreenState();
}

class _UserHistoryScreenState extends State<UserHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final orderProv = Provider.of<OrderService>(context, listen: true);
    final authProv = Provider.of<AuthService>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                orderProv.getOrderByUser(
                  token: authProv.token,
                  userId: authProv.userData!.id.toString(),
                );
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          if (orderProv.historyOrder.isEmpty) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: const Text('Tidak ada riwayat pesanan'),
                  ),
                  MyButton(
                    child:
                        Text('Refresh', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      setState(() {
                        orderProv.getOrderByUser(
                          token: authProv.token,
                          userId: authProv.userData!.id.toString(),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
          if (orderProv.historyOrder.isNotEmpty) ...[
            Expanded(
              child: ListView.builder(
                itemCount: orderProv.historyOrder.length,
                itemBuilder: (context, index) {
                  final data = orderProv.historyOrder[index];
                  return ListTile(
                      title: Text('Kopi ${data.merchant.user.name}'),
                      subtitle: Text('${data.address}'),
                      trailing: data.doneAt != null
                          ? Text('${formatDateTime(data.doneAt!)}')
                          : Text('Dalam Proses'),
                      onTap: () => data.doneAt == null
                          ? Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                              return WaitingAccept(id: data.id.toString());
                            }))
                          : null);
                },
              ),
            )
          ]
        ],
      ),
    );
  }
}
