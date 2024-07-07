import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

import 'screens/home/provider/order_service.dart';
import 'screens/login/provider/auth_service.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => AuthService()),
  ChangeNotifierProvider(create: (_) => OrderService()),
  // Add providers here...
];
