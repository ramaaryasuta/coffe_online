import 'package:coffeonline/screens/home/UI/user_riwayat.dart';
import 'package:coffeonline/screens/home/widgets/button_order.dart';
import 'package:coffeonline/screens/home/widgets/merch_map.dart';
import 'package:coffeonline/screens/home/widgets/merch_order.dart';
import 'package:coffeonline/screens/login/provider/auth_service.dart';
import 'package:coffeonline/screens/orders/models/order_model.dart';
import 'package:coffeonline/utils/loading.dart';
import 'package:coffeonline/utils/print_log.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../utils/socket/socket_service.dart';
import '../../home-merchant/provider/merchant_service.dart';
import '../provider/order_service.dart';

class MerchMenu extends StatefulWidget {
  const MerchMenu({super.key});

  @override
  State<MerchMenu> createState() => _MerchMenuState();
}

class _MerchMenuState extends State<MerchMenu> {
  TextEditingController stockController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool isRequestedOrder = false;
  OrderResponse? order;
  OrderResponse? orderPrev;
  bool isFetched = false;
  late Future<void> fetchOrderHistoryFuture;

  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;

  final List<Map<String, String>> coffeeList = [
    {
      "image":
          "https://img.freepik.com/free-photo/fresh-coffee-steams-wooden-table-close-up-generative-ai_188544-8923.jpg",
      "coffee_name": "Espresso",
      "desc": "Kopi dengan rasa penuh, disajikan dalam porsi kecil dan kuat."
    },
    {
      "image":
          "https://images.unsplash.com/photo-1543256840-0709ad5d3726?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8Y29mZmVlJTIwcGhvdG9ncmFwaHl8ZW58MHx8MHx8fDA%3D",
      "coffee_name": "Latte",
      "desc": "Minuman kopi yang dibuat dengan espresso dan susu yang dikukus."
    },
    {
      "image":
          "https://somedayilllearn.com/wp-content/uploads/2020/05/cup-of-black-coffee-scaled-720x540.jpeg",
      "coffee_name": "Cappuccino",
      "desc": "Minuman kopi berbasis espresso dengan busa susu di atasnya."
    },
    {
      "image":
          "https://www.allrecipes.com/thmb/Hqro0FNdnDEwDjrEoxhMfKdWfOY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/21667-easy-iced-coffee-ddmfs-4x3-0093-7becf3932bd64ed7b594d46c02d0889f.jpg",
      "coffee_name": "Americano",
      "desc":
          "Espresso yang dicampur dengan air panas untuk menghasilkan rasa kopi yang lebih ringan."
    },
    {
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXwck4mtr1y1MulgaJWP79_3t4yO57dS0dGw&s",
      "coffee_name": "Mocha",
      "desc": "Kombinasi antara kopi, cokelat, dan susu yang dikukus."
    },
    {
      "image":
          "https://static.scientificamerican.com/sciam/cache/file/4A9B64B5-4625-4635-848AF1CD534EBC1A_source.jpg?w=1200",
      "coffee_name": "Macchiato",
      "desc": "Espresso dengan sedikit busa susu di atasnya."
    }
  ];

  @override
  void dispose() {
    stockController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrderHistory() async {
    final authService = context.read<AuthService>();
    final orderService = context.read<OrderService>();
    printLog("function order merchant called ${authService.token}");
    await orderService.getOrderByMerchant(
      token: authService.token,
      merchantId: authService.userData!.merchId,
    );
  }

  void _fetchOrderRequest() async {
    final authService = context.read<AuthService>();
    final orderService = context.read<OrderService>();
    printLog("function order merchant called ${authService.token}");
    await orderService.getOrderRequested(
      token: authService.token,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchOrderHistory();
    _fetchOrderRequest();
    printLog('merch menu init');
  }

  @override
  Widget build(BuildContext context) {
    print('MerchMenu build called');
    final merchProv = context.watch<MerchantService>();
    final userProv = Provider.of<AuthService>(context, listen: true);
    final _orderService = context.watch<OrderService>();
    final socketService = Provider.of<SocketServices>(context, listen: true);

    socketService.socket.connect();
    socketService.socket.on('${userProv.userId}-request-order', (data) {
      printLog('Socket mencari penjual..., $data');
      order = OrderResponse.fromJson(data);
      printLog("order ${order!.id}, count ${merchProv.count}");
      if (merchProv.count < 1) {
        _showOrderDialog(context, order!, userProv);
        merchProv.incrementCount();
      }
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 8.0, 0.0),
      child: RefreshIndicator(
        onRefresh: () async {
          await _fetchOrderHistory();
        },
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    runAlignment: WrapAlignment.spaceEvenly,
                    direction: Axis.vertical,
                    children: [
                      MyButton(
                        child: const Text('Riwayat',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return UserHistoryScreen();
                            },
                          ));
                        },
                      ),
                      MyButton(
                        child: const Text('Perbarui Informasi',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          _MerchMenuState().showDialogMerch();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_orderService.orderRequestResponse != null) ...[
                  Text('Request Order :',
                      style: Theme.of(context).textTheme.titleLarge),
                  Container(
                      width: double.infinity,
                      height: 100,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                                '${_orderService.orderRequestResponse!.id}'),
                            subtitle: Text(
                                'Alamat: ${_orderService.orderRequestResponse!.address}'),
                            onTap: () {
                              _showOrderDialog(
                                  context,
                                  _orderService.orderRequestResponse!,
                                  userProv);
                              _orderService.resetOrderRequest();
                              merchProv.decrementCount();
                            },
                          ),
                        ],
                      )),
                ],
                Container(
                  height: 120.0, // Set the height of the carousel
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: coffeeList.length,
                    itemBuilder: (context, index) {
                      final coffee = coffeeList[index];
                      return Container(
                        width: 180.0, // Set the width of each item
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            coffee["image"]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text('Ongoing Order :',
                    style: Theme.of(context).textTheme.titleLarge),
                Container(
                  width: double.infinity,
                  height: 150,
                  child: ListView.builder(
                    itemCount: _orderService.historyOrder.length,
                    itemBuilder: (context, index) {
                      final order = _orderService.historyOrder[index];
                      if (order.status == 'ongoing') {
                        return Column(
                          children: [
                            ListTile(
                              title: Text('Order ID ${order.id}'),
                              subtitle: Text('Alamat: ${order.address}'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return MerchOrder(
                                      orderId: order.id.toString(),
                                    );
                                  },
                                ));
                              },
                            ),
                            const Divider(),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDialog(
    BuildContext context,
    OrderResponse order,
    AuthService userProv,
  ) {
    final _orderService = context.read<OrderService>();
    final merchProv = context.read<MerchantService>();
    double lat = 0.0;
    double long = 0.0;
    String formatPrice(double price) {
      String priceString = price.toStringAsFixed(
          2); // Convert price to a string with 2 decimal places
      List<String> parts = priceString
          .split('.'); // Split the string into integer and decimal parts

      String integerPart = parts[0];
      String decimalPart =
          parts.length > 1 ? parts[1] : ''; // Check if there are decimal places

      // Add thousand separators to the integer part
      String formattedInteger = '';
      for (int i = integerPart.length - 1; i >= 0; i--) {
        formattedInteger = integerPart[i] + formattedInteger;
        if ((integerPart.length - i) % 3 == 0 && i != 0) {
          formattedInteger = '.' + formattedInteger; // Add thousand separator
        }
      }

      return 'Rp. $formattedInteger${decimalPart.isNotEmpty ? '.' + decimalPart : ''}'; // Combine integer, decimal, and "Rp." prefix
    }

    Future<void> getLocation() async {
      try {
        LoadingDialog.show(context, message: 'Mendapatkan lokasi...');
        // Periksa layanan lokasi aktif
        bool _serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!_serviceEnabled) {
          // Jika layanan tidak aktif, minta untuk diaktifkan
          _serviceEnabled = await Geolocator.openLocationSettings();
          if (!_serviceEnabled) {
            return;
          }
        }

        // Periksa izin lokasi
        LocationPermission _permission = await Geolocator.checkPermission();
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
          // Update merchLoc with the obtained position
          setState(() {
            lat = position.latitude;
            long = position.longitude;
          });
          LoadingDialog.hide(context);
        }
      } catch (e) {
        printLog('Error: $e');
        LoadingDialog.hide(context);
      }
    }

    getLocation().then((_) => showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                insetPadding: EdgeInsets.all(0),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      AppBar(
                        title: Text('Request Order'),
                        automaticallyImplyLeading: false,
                        actions: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              merchProv.decrementCount();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text("Jumlah Kopi"),
                                      Text(
                                        order.amount.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text("Estimasi Biaya"),
                                      Text(
                                          formatPrice(
                                              double.parse(order.totalPrice)),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                    ],
                                  ),
                                ],
                              ),
                              ListTile(
                                title: Text(
                                  order.user.name.toUpperCase(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                subtitle: Text(
                                    "Alamat: ${order.address} \nCatatan: ${order.addressDetail}"),
                              ),
                              Container(
                                  padding: EdgeInsets.all(18),
                                  margin: EdgeInsets.only(bottom: 20),
                                  height: 400,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: MerchMap(
                                    latitudeBuyer: order.latitudeBuyer,
                                    longitudeBuyer: order.longitudeBuyer,
                                    latitudeMerchant: lat,
                                    longitudeMerchant: long,
                                  )),
                              MyButton(
                                child: Text(
                                  'Terima Order',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.white),
                                ),
                                onPressed: () {
                                  _orderService.ongoingOrder(
                                    token: userProv.token,
                                    merchantId:
                                        userProv.userData!.merchId.toString(),
                                    orderId: order.id.toString(),
                                  );
                                  merchProv.decrementCount();
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return MerchOrder(
                                        orderId: order.id.toString(),
                                      );
                                    },
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ));
          },
        ).then((value) => {
              merchProv.decrementCount(),
            }));
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
              child: const Text('Perbarui Data & Lokasi',
                  style: TextStyle(color: Colors.white)),
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
