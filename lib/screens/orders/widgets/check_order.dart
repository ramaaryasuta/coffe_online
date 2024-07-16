import 'package:coffeonline/screens/orders/models/ongoing_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/provider/order_service.dart';
import '../../home/widgets/button_order.dart';

// ignore: must_be_immutable
class CheckOrderButton extends StatefulWidget {
  CheckOrderButton({
    super.key,
    required this.dataOngoing,
  });

  OngoingResponse dataOngoing;

  @override
  State<CheckOrderButton> createState() => _CheckOrderButtonState();
}

class _CheckOrderButtonState extends State<CheckOrderButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          child: MyButton(
            child: Text(
              'Cek Pesananmu',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
            onPressed: () =>
                showCekOrder(context, dataOngoing: widget.dataOngoing),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black54,
            ),
            child: Text(
              'Kembali Ke Halaman Utama',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        )
      ],
    );
  }

  void showCekOrder(BuildContext context, {OngoingResponse? dataOngoing}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cek Pesananmu',
                      style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ini Pesananmu',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text('- ${dataOngoing!.amount} Gelas Kopi'),
                      Text(
                          '- Dengan Harga maksimal Rp.${dataOngoing.totalPrice}'),
                      Text('- Alamat kamu berada di ${dataOngoing.address}'),
                      Text('- Dengan catatan ${dataOngoing.addressDetail}'),
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Penjual',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(
                          '- ${dataOngoing.merchant.user.name} Menerima Pesanan'),
                      Text(
                          '- Dapat Dohubungi pada nomor : ${dataOngoing.merchant.user.phoneNumber} '),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
