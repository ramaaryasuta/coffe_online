import 'package:coffeonline/screens/home/widgets/button_order.dart';
import 'package:coffeonline/screens/home/widgets/map_user.dart';
import 'package:coffeonline/screens/login/provider/auth_service.dart';
import 'package:coffeonline/screens/home-merchant/provider/merchant_service.dart';
import 'package:coffeonline/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../utils/print_log.dart';
import '../provider/order_service.dart';

class SearchCoffe extends StatefulWidget {
  const SearchCoffe({
    super.key,
  });

  @override
  State<SearchCoffe> createState() => _SearchCoffeState();
}

class _SearchCoffeState extends State<SearchCoffe> {
  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;
  @override
  Widget build(BuildContext context) {
    final providerMerch = context.watch<MerchantService>();
    final orderProv = context.read<OrderService>();
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                providerMerch.listMerchant.isNotEmpty
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'ada ${providerMerch.listMerchant.length} kopi favorit\n Berada didekat mu, loh!',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Container(
                                child: UserMap(
                                  latitudeBuyer: orderProv.myLat,
                                  longitudeBuyer: orderProv.myLong,
                                  coordinates: providerMerch.listMerchant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Temukan Kopi Terdekat',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(),
                          ),
                        ],
                      ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: MyButton(
                  onPressed: () {
                    requestPermissionAndGetLocation();
                  },
                  child: providerMerch.listMerchant.isNotEmpty
                      ? const Text(
                          'Refresh',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Cari Sekarang',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> requestPermissionAndGetLocation() async {
    final provider = context.read<AuthService>();
    final orderProv = context.read<OrderService>();
    LoadingDialog.show(context, message: 'Memuat Data...');
    try {
      // Periksa layanan lokasi aktif
      _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        // Jika layanan tidak aktif, minta untuk diaktifkan
        _serviceEnabled = await Geolocator.openLocationSettings();
        if (!_serviceEnabled) {
          return;
        }
      }

      // Periksa izin lokasi
      _permission = await Geolocator.checkPermission();
      if (_permission == LocationPermission.denied) {
        // Jika izin belum diberikan, minta izin
        _permission = await Geolocator.requestPermission();
        if (_permission == LocationPermission.denied) {
          // Izin ditolak, berikan penanganan khusus di sini
          // Misalnya, menampilkan pesan atau menavigasi ke pengaturan aplikasi
          return;
        }
      }

      if (_permission == LocationPermission.deniedForever) {
        // Jika pengguna telah menolak untuk memberikan izin secara permanen
        // Tindakan lebih lanjut, misalnya memberikan pesan tentang pengaturan aplikasi
        return;
      }

      // Jika izin sudah diberikan, lanjutkan ke pengambilan lokasi
      if (_permission == LocationPermission.whileInUse ||
          _permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        printLog(
            'Latitude: ${position.latitude}, Longitude: ${position.longitude}');
        // Lakukan sesuatu dengan posisi yang diperoleh
        await context.read<MerchantService>().searchNearbyMerchant(
              token: provider.token,
              lat: position.latitude.toString(),
              long: position.longitude.toString(),
              stock: 1,
            );
        LoadingDialog.hide(context);
        orderProv.saveMyLatLang(position.latitude, position.longitude);
        if (context.read<MerchantService>().listMerchant.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text('Tidak ada kopi yang tersedia'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              content: Text(
                  'Tersedia ${context.read<MerchantService>().listMerchant.length} kopi yang tersedia'),
            ),
          );
        }
      }
    } catch (e) {
      printLog('Error: $e');
    }
  }
}
