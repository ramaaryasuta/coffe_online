import 'package:coffeonline/screens/home/widgets/button_order.dart';
import 'package:coffeonline/screens/orders/map_screen.dart';
import 'package:coffeonline/screens/orders/models/ongoing_model.dart';
import 'package:coffeonline/utils/print_log.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/socket/socket_service.dart';
import '../home/provider/order_service.dart';
import '../login/provider/auth_service.dart';
import 'widgets/text_menu.dart';

class WaitingAccept extends StatefulWidget {
  const WaitingAccept({super.key});

  @override
  State<WaitingAccept> createState() => _WaitingAcceptState();
}

class _WaitingAcceptState extends State<WaitingAccept> {
  bool isAcceptedOrder = false;
  OngoingResponse? order;

  @override
  void initState() {
    super.initState();
    final socketService = Provider.of<SocketServices>(context, listen: false);
    final userProv = Provider.of<AuthService>(context, listen: false);

    socketService.socket.connect();
    socketService.socket.on('${userProv.userId}-ongoing-order', _handleOrder);
  }

  void _handleOrder(dynamic data) async {
    printLog('Socket mencari penjual acc');
    printLog(data);
    order = await OngoingResponse.fromJson(data);
    if (mounted) {
      setState(() {
        printLog('ini order $order');
        isAcceptedOrder = true;
      });
    }
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketServices>(context, listen: false);
    final userProv = Provider.of<AuthService>(context, listen: false);

    socketService.socket.off('${userProv.userId}-ongoing-order', _handleOrder);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProv = Provider.of<OrderService>(context, listen: true);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isAcceptedOrder) ...[
              SvgPicture.asset(
                'assets/waiting.svg',
                height: 200,
                width: 200,
              ),
              Text(
                'Mencari Penjual yang siap melayani',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MenuTextDetail(
                        text:
                            '- Jumlah Gelas: ${orderProv.orderResponse!.amount}',
                      ),
                      MenuTextDetail(
                        text:
                            '- Harga Maksimal: ${orderProv.orderResponse!.totalPrice}',
                      ),
                      MenuTextDetail(
                        text:
                            '- Alamat Kamu: ${orderProv.orderResponse!.address}',
                      ),
                      MenuTextDetail(
                        text:
                            '- Catatan: ${orderProv.orderResponse!.addressDetail}',
                      ),
                      MenuTextDetail(
                        text: '- Order ID: ${orderProv.orderResponse!.id}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (isAcceptedOrder) ...[
              SvgPicture.asset(
                'assets/accept.svg',
                height: 200,
                width: 200,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Penjual Berhasil Menerima Pesanan Anda',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              MyButton(
                child: Text('Cek Lokasi',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return MapScreen(
                        ongoingData: order!,
                      );
                    },
                  ));
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
