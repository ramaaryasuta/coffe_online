import 'package:flutter/material.dart';

import 'button_order.dart';

class SearchCoffe extends StatelessWidget {
  const SearchCoffe({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Temukan Kopi Terdekat dari Lokasi mu Sekarang',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(),
            ),
            const SizedBox(height: 10),
            MyButton(
              child: Text('Cari Kopi',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}