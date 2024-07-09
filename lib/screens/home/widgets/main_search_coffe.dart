import 'package:coffeonline/screens/home/widgets/button_order.dart';
import 'package:coffeonline/screens/login/provider/auth_service.dart';
import 'package:coffeonline/screens/home-merchant/provider/merchant_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchCoffe extends StatefulWidget {
  const SearchCoffe({
    super.key,
  });

  @override
  State<SearchCoffe> createState() => _SearchCoffeState();
}

class _SearchCoffeState extends State<SearchCoffe> {
  @override
  Widget build(BuildContext context) {
    final providerUser = context.watch<AuthService>();
    final providerMerch = context.watch<MerchantService>();
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            providerMerch.listMerchant.isNotEmpty
                ? Text(
                    'ada ${providerMerch.listMerchant.length} kopi favorit\n Berada didekat mu, loh!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(),
                  )
                : Text(
                    'Temukan Kopi Terdekat',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(),
                  ),
            const SizedBox(height: 10),
            MyButton(
              onPressed: () {
                context.read<MerchantService>().searchNearbyMerchant(
                      token: providerUser.token,
                      lat: "37.7740",
                      long: "-122.4180",
                      stock: 0,
                    );
              },
              child: const Text(
                'Cek Sekarang',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
