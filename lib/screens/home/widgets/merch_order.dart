import 'package:coffeonline/screens/home/widgets/button_order.dart';
import 'package:coffeonline/screens/home/widgets/merch_map.dart';
import 'package:coffeonline/screens/login/provider/auth_service.dart';

import 'package:coffeonline/utils/print_log.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order_service.dart';

class MerchOrder extends StatefulWidget {
  final String orderId;

  MerchOrder({super.key, required this.orderId});

  @override
  State<MerchOrder> createState() => _MerchOrderState();
}

class _MerchOrderState extends State<MerchOrder> {
  void _fetchOrderHistory() {
    final _authService = context.read<AuthService>();
    final _orderService = context.read<OrderService>();
    _orderService.getOrderById(
      token: _authService.token,
      orderId: widget.orderId,
    );
  }

  void _completeOrder() {
    final _authService = context.read<AuthService>();
    final _orderService = context.read<OrderService>();
    _orderService.completeOrder(
        token: _authService.token, orderId: widget.orderId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrderHistory();
      printLog('done fetch');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('MerchOrder build called');
    final _authService = context.read<AuthService>();
    final userProv = Provider.of<AuthService>(context, listen: true);
    final _orderService = context.watch<OrderService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Info',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${_orderService.ongoingResponse?.id ?? 'Loading...'}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Nama: ${_orderService.ongoingResponse?.user.name ?? 'Loading...'}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Alamat: ${_orderService.ongoingResponse?.address ?? 'Loading...'}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Detail: ${_orderService.ongoingResponse?.addressDetail ?? 'Loading...'}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Total: ${_orderService.ongoingResponse?.totalPrice ?? 'Loading...'}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Status: ${_orderService.ongoingResponse?.status ?? 'Loading...'}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(18),
                margin: EdgeInsets.only(bottom: 20),
                height: 400,
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: MerchMap(
                    latitudeBuyer: _orderService.ongoingResponse!.latitudeBuyer,
                    longitudeBuyer:
                        _orderService.ongoingResponse!.longitudeBuyer,
                    latitudeMerchant: 37.67819,
                    longitudeMerchant: -122.017291)),
            Center(
                child: MyButton(
                    child: Text('Complete Order',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _completeOrder();
                      Navigator.pop(context);
                    })),
          ],
        ),
      ),
    );
  }
}
