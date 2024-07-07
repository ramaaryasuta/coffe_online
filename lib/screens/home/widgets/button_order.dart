import 'package:coffeonline/screens/home/provider/order_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../styles/colors.dart';
import '../../../utils/print_log.dart';
import '../../login/provider/auth_service.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
  });

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final budgetController = TextEditingController();
  final addressController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    budgetController.dispose();
    addressController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          MyButton(
            onPressed: () => orderMenu(context),
            child: Row(
              children: [
                Text(
                  'Atur Pesanan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_upward_outlined,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void orderMenu(BuildContext context) {
    double initialChildSize = 0.5;
    double minChildSize = 0.25;
    double maxChildSize = 0.8;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Atur Pesananmu',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Jumlah Pesanan Kopi',
                          hintText: 'Masukan Jumlah pesanan',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: budgetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Biaya Maksimal',
                          prefixText: 'Rp. ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: addressController,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          labelText: 'Alamat',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: noteController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Catatan Pesanan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        onPressed: () => createOrder(),
                        child: const Text('Buat Pesanan'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> createOrder() async {
    final provider = context.read<OrderService>();
    final userProv = context.read<AuthService>();
    try {
      await provider.createOrder(
        token: userProv.token,
        amount: int.parse(amountController.text),
        maxPrice: budgetController.text,
        address: addressController.text,
        note: noteController.text,
        longitudeBuyer: 0,
        latitudeBuyer: 0,
        userId: userProv.userId!,
      );
    } catch (e) {
      printLog(e);
    }
  }
}

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    this.onPressed,
    required this.child,
  });

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          colors: [
            MyColor.primaryColor,
            MyColor.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: child,
      ),
    );
  }
}
