import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../utils/print_log.dart';
import 'widgets/button_order.dart';
import 'widgets/header_user.dart';
import 'widgets/main_search_coffe.dart';
import 'widgets/menu_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging.instance;

    // Request permissions for iOS
    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Configure message handlers
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      printLog('Received a message while in the foreground!');
      printLog('Message data: ${message.data}');

      if (message.notification != null) {
        printLog(
            'Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      printLog('Message clicked!');
      if (message.notification != null) {
        printLog('Notification: ${message.notification}');
      }
    });

    // Handle when the app is launched by a notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        printLog('App launched by notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderUserAccount(),
            MenuContainer(),
            SearchCoffe(),
            OrderButton(),
          ],
        ),
      ),
    );
  }
}
