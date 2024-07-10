import 'package:coffeonline/screens/home-merchant/provider/merchant_service.dart';
import 'package:coffeonline/screens/home/widgets/button_order.dart';
import 'package:coffeonline/utils/loading.dart';
import 'package:coffeonline/utils/print_log.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../login/provider/auth_service.dart';

class HeaderUserAccount extends StatefulWidget {
  const HeaderUserAccount({
    super.key,
  });

  @override
  State<HeaderUserAccount> createState() => _HeaderUserAccountState();
}

class _HeaderUserAccountState extends State<HeaderUserAccount> {
  TextEditingController stockController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;

  @override
  void dispose() {
    stockController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthService>();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hallo, ${provider.userData?.name ?? 'User'}!',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 5),
              Text('Mau Ngopi Kapan nih?',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const Spacer(),
          if (provider.userData?.type == 'merchant') ...[
            IconButton(
              onPressed: () {
                showDialogMerch();
              },
              icon: const Icon(Icons.settings),
            )
          ]
        ],
      ),
    );
  }

  void showDialogMerch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Perbarui Merchant Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stock',
              ),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga Satuan',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MyButton(
              child:
                  const Text('Perbarui', style: TextStyle(color: Colors.white)),
              onPressed: () {
                updateMerchInfo().then((value) => Navigator.pop(context));
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateMerchInfo() async {
    final provider = context.read<MerchantService>();
    final authProv = context.read<AuthService>();
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
        await provider.updateMerchInfo(
          id: authProv.userData!.merchId.toString(),
          token: authProv.token,
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
          stock: stockController.text,
          price: priceController.text,
        );
        LoadingDialog.hide(context);
      }
    } catch (e) {
      printLog('Error: $e');
    }
  }
}
