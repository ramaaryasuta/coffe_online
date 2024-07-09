import 'package:coffeonline/utils/print_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServices with ChangeNotifier {
  IO.Socket socket = IO.io(dotenv.env['BASEURL'].toString(), <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });
  bool isConnected = false;

  var message;
  bool isAccept = false;

  void connected() {
    socket.on('connect', (_) {
      isConnected = true;
      printLog('Socket connected...');
      notifyListeners();
    });
    notifyListeners();
  }
}
