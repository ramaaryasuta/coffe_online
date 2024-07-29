import 'package:coffeonline/screens/home/provider/coffee_service.dart';
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
  List<String> selectedCoffeeNames = [];
  List<int> selectedCoffeeIds = [];

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
                  'Pesan Sekarang',
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

  void _showCoffeeSelectionDialog(BuildContext context,
      Function(List<String>, List<int>) onSelectionChanged) {
    final coffeeService = context.read<CoffeeService>();

    if (coffeeService.coffeeData.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pilih Kopi'),
            content: const Center(child: CircularProgressIndicator()),
          );
        },
      );

      coffeeService.getCoffee().then((_) {
        Navigator.of(context).pop(); // Close the loading dialog
        _showCoffeeSelectionDialog(
            context, onSelectionChanged); // Reopen the dialog
      });

      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Kopi'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter dialogSetState) {
              final coffeeItems = coffeeService.coffeeData;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: coffeeItems.map((coffee) {
                  final coffeeName = coffee["name"].toString();
                  final coffeeId = coffee["id"] as int;
                  final isSelected = selectedCoffeeIds.contains(coffeeId);

                  return CheckboxListTile(
                    title: Text(coffeeName),
                    value: isSelected,
                    onChanged: (bool? value) {
                      dialogSetState(() {
                        if (value == true) {
                          selectedCoffeeIds.add(coffeeId);
                          selectedCoffeeNames.add(coffeeName);
                        } else {
                          selectedCoffeeIds.remove(coffeeId);
                          selectedCoffeeNames.remove(coffeeName);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Notify the parent widget of the change
                onSelectionChanged(selectedCoffeeNames, selectedCoffeeIds);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Jumlah Pesanan Kopi',
                          hintText: 'Masukan Jumlah pesanan',
                          hintStyle: const TextStyle(color: Colors.grey),
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
                      MyButton(
                        child: const Text('Pilih Kopi',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          _showCoffeeSelectionDialog(
                            context,
                            (selectedNames, selectedIds) {
                              setState(() {
                                selectedCoffeeNames = selectedNames;
                                selectedCoffeeIds = selectedIds;
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text('Kopi Terpilih: ${selectedCoffeeNames.join(', ')}'),
                      const SizedBox(height: 10),
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
                      SizedBox(
                        width: double.infinity,
                        child: MyButton(
                          onPressed: () {
                            createOrder().then(
                              (value) {
                                Navigator.pushNamed(context, '/waiting');
                              },
                            );
                          },
                          child: Text(
                            'Buat Pesanan',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
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
    provider.saveOrderData(
      amountCoffe: int.parse(amountController.text),
      maxPrice: budgetController.text,
      address: addressController.text,
      note: noteController.text,
      coffeeID: selectedCoffeeIds,
    );
    try {
      await provider.createOrder(
        token: userProv.token,
        amount: int.parse(amountController.text),
        maxPrice: budgetController.text,
        address: addressController.text,
        note: noteController.text,
        coffeeID: selectedCoffeeIds,
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
