import 'package:coffeonline/screens/home/UI/user_riwayat.dart';
import 'package:coffeonline/screens/home/provider/coffee_service.dart';
import 'package:coffeonline/screens/home/subview/galery_coffe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../styles/colors.dart';

class MenuContainer extends StatelessWidget {
  const MenuContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: MyColor.primaryColor.withOpacity(0.3),
            offset: const Offset(2, 4),
            blurRadius: 5,
          ),
        ],
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          MenuButton(
            icon: Icons.coffee_outlined,
            title: 'Kopi menu',
            onTap: () async {
              final coffeeService =
                  Provider.of<CoffeeService>(context, listen: false);
              await coffeeService.getCoffee(); // Fetch data

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return GaleryCoffeScreem(
                        coffeeList: coffeeService.coffeeData);
                  },
                ),
              );
            },
          ),
          MenuButton(
            icon: Icons.history_rounded,
            title: 'Riwayat',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const UserHistoryScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black26)),
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: const BeveledRectangleBorder()),
            child: Icon(
              icon,
              color: MyColor.primaryColor,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
