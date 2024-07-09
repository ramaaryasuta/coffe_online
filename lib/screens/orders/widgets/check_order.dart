import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/provider/order_service.dart';
import '../../home/widgets/button_order.dart';

class CheckOrderButton extends StatelessWidget {
  const CheckOrderButton({
    super.key,
  });

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
            onPressed: () => showCekOrder(context),
          ),
        ),
      ],
    );
  }

  void showCekOrder(BuildContext context) {
    final provider = context.read<OrderService>();
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
              Text('${provider.amountCoffe} Gelas Kopi'),
              Text('Dengan Harga maksimal Rp.${provider.maxPrice}'),
              Text('Alamat kamu berada di ${provider.address}'),
              Text('Dengan catatan ${provider.note}'),
            ],
          ),
        );
      },
    );
  }
}
