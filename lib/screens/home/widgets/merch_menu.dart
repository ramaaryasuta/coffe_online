import 'package:coffeonline/screens/home/widgets/button_order.dart';
import 'package:coffeonline/screens/home/widgets/merch_map.dart';
import 'package:coffeonline/screens/home/widgets/merch_order.dart';
import 'package:coffeonline/screens/login/provider/auth_service.dart';
import 'package:coffeonline/screens/orders/models/order_model.dart';
import 'package:coffeonline/utils/print_log.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/socket/socket_service.dart';
import '../provider/order_service.dart';

class MerchMenu extends StatefulWidget {
  const MerchMenu({super.key});

  @override
  State<MerchMenu> createState() => _MerchMenuState();
}

class _MerchMenuState extends State<MerchMenu> {
  bool isRequestedOrder = false;
  OrderResponse? order;
  OrderResponse? orderPrev;
  bool isFetched = false;
  late Future<void> fetchOrderHistoryFuture;

  void _fetchOrderHistory() async {
    final authService = context.read<AuthService>();
    final orderService = context.read<OrderService>();
    printLog("function order merchant called ${authService.token}");
    await orderService.getOrderByMerchant(
      token: authService.token,
      merchantId: authService.userData!.merchId,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchOrderHistory();
    printLog('merch menu init');
  }

  @override
  Widget build(BuildContext context) {
    print('MerchMenu build called');
    final userProv = Provider.of<AuthService>(context, listen: true);
    final _orderService = context.watch<OrderService>();
    final socketService = Provider.of<SocketServices>(context, listen: true);

    socketService.socket.connect();
    socketService.socket.on('${userProv.userId}-request-order', (data) {
      printLog('Socket mencari penjual...');
      printLog(data);
      order = OrderResponse.fromJson(data);
      if (order != orderPrev) {
        orderPrev = order;
        _showOrderDialog(context, order!, userProv);
      }
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 8.0, 0.0),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyButton(
                  child: const Text('Refresh Order',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    _fetchOrderHistory();
                  }),
              Text('Ongoing Order',
                  style: Theme.of(context).textTheme.titleLarge),
              Container(
                width: double.infinity,
                height: 200,
                child: ListView.builder(
                  itemCount: _orderService.historyOrder.length,
                  itemBuilder: (context, index) {
                    final order = _orderService.historyOrder[index];
                    if (order.status == 'ongoing') {
                      return ListTile(
                        title: Text(order.id.toString()),
                        subtitle: Text(order.status),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return MerchOrder(
                                orderId: order.id.toString(),
                              );
                            },
                          ));
                        },
                      );
                    }
                    // else {
                    //   if (index == 0) {
                    //     return Container(
                    //       height: 200,
                    //       child: Center(child: Text('No ongoing order')),
                    //     );
                    //   } else {
                    //     return Container();
                    //   }
                    // }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'History Order',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                width: double.infinity,
                height: 300,
                child: ListView.builder(
                  itemCount: _orderService.historyOrder.length,
                  itemBuilder: (context, index) {
                    final order = _orderService.historyOrder[index];
                    if (order.status == 'completed') {
                      return ListTile(
                        title: Text(order.id.toString()),
                        subtitle: Text(order.status),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOrderDialog(
    BuildContext context,
    OrderResponse order,
    AuthService userProv,
  ) {
    final _orderService = context.read<OrderService>();

    String formatPrice(double price) {
      String priceString = price.toStringAsFixed(
          2); // Convert price to a string with 2 decimal places
      List<String> parts = priceString
          .split('.'); // Split the string into integer and decimal parts

      String integerPart = parts[0];
      String decimalPart =
          parts.length > 1 ? parts[1] : ''; // Check if there are decimal places

      // Add thousand separators to the integer part
      String formattedInteger = '';
      for (int i = integerPart.length - 1; i >= 0; i--) {
        formattedInteger = integerPart[i] + formattedInteger;
        if ((integerPart.length - i) % 3 == 0 && i != 0) {
          formattedInteger = '.' + formattedInteger; // Add thousand separator
        }
      }

      return 'Rp. $formattedInteger${decimalPart.isNotEmpty ? '.' + decimalPart : ''}'; // Combine integer, decimal, and "Rp." prefix
    }

    if (order != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.all(0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  AppBar(
                    title: Text('Request Order'),
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text("Jumlah Kopi"),
                                      Text(order.amount.toString()),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text("Estimasi Biaya"),
                                      Text(formatPrice(
                                          double.parse(order.totalPrice))),
                                    ],
                                  ),
                                ],
                              ),
                              ListTile(
                                title: Text(order.user.name),
                                subtitle: Text(
                                    "Alamat: ${order.address} \nCatatan: ${order.addressDetail}"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Text("Lokasi Pembeli",
                      style: Theme.of(context).textTheme.titleLarge),
                  Container(
                      padding: EdgeInsets.all(18),
                      margin: EdgeInsets.only(bottom: 20),
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: MerchMap(
                          latitudeBuyer: order.latitudeBuyer,
                          longitudeBuyer: order.longitudeBuyer,
                          latitudeMerchant: 37.67819,
                          longitudeMerchant: -122.017291)),
                  MyButton(
                    child: Text(
                      'Terima Order',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      _orderService.ongoingOrder(
                        token: userProv.token,
                        merchantId: userProv.userData!.merchId.toString(),
                        orderId: order.id.toString(),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
