import 'package:coffeonline/screens/home/widgets/button_order.dart';
import 'package:coffeonline/screens/orders/waiting_accept.dart';
import 'package:coffeonline/utils/date_convert.dart';
import 'package:coffeonline/utils/loading.dart';
import 'package:coffeonline/utils/print_log.dart';
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
              LoadingDialog.show(context, message: 'Mengambil data...');
              printLog('Refresh app bar');
              if (authProv.typeUser == 'user') {
                setState(() {
                  orderProv.getOrderByUser(
                    token: authProv.token,
                    userId: authProv.userData!.id.toString(),
                  );
                });
              } else {
                setState(() {
                  orderProv.getOrderByMerchant(
                    token: authProv.token,
                    merchantId: authProv.userData!.merchId,
                  );
                });
              }
              LoadingDialog.hide(context);
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
                      printLog('Dari button tengah');
                      LoadingDialog.show(context, message: 'Mengambil data...');
                      setState(() {
                        orderProv.getOrderByUser(
                          token: authProv.token,
                          userId: authProv.userData!.id.toString(),
                        );
                        LoadingDialog.hide(context);
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
                  return InkWell(
                    onTap: () => data.doneAt == null
                        ? Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                            return WaitingAccept(id: data.id.toString());
                          }))
                        : null,
                    child: Card(
                      elevation: 4.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Penjual : Kopi ${data.merchant.user.name}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Alamat Pesanan: ${data.address}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Harga: Rp.${data.totalPrice}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Jumlah Pesanan: ${data.amount} pcs',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: data.doneAt != null
                                  ? Text(
                                      '${formatDateTime(data.doneAt!)}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[800],
                                      ),
                                    )
                                  : Text(
                                      'Dalam Proses',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ]
        ],
      ),
    );
  }
}
