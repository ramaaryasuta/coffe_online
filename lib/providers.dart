import 'package:coffeonline/utils/socket/socket_service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

import 'screens/home-merchant/provider/merchant_service.dart';
import 'screens/home/provider/order_service.dart';
import 'screens/login/provider/auth_service.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => AuthService()),
  ChangeNotifierProvider(create: (_) => OrderService()),
  ChangeNotifierProvider(create: (_) => MerchantService()),
  ChangeNotifierProvider(create: (_) => SocketServices())
  // Add providers here...
];
