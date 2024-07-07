import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../utils/api.dart';
import '../../../utils/api_path.dart';
import '../../../utils/print_log.dart';

class OrderService with ChangeNotifier {
  final APIservice apiService = APIservice();

  bool successOrder = false;

  Future<void> createOrder({
    required String token,
    required int amount,
    required String maxPrice,
    required String address,
    required String note,
    required double longitudeBuyer,
    required double latitudeBuyer,
    required int userId,
  }) async {
    try {
      Response response = await apiService.postApi(
        path: APIpath.createOrder,
        headers: {'Authorization': 'Bearer $token'},
        data: {
          'amount': amount,
          'totalPrice': maxPrice,
          'address': address,
          'address_detail': note, // for detail change to note buyer
          'longitude_buyer': longitudeBuyer,
          'latitude_buyer': latitudeBuyer,
          'userID': userId
        },
      );
      if (response.statusCode == 201) {
        successOrder = true;
        printLog(response.data);
        notifyListeners();
      } else {
        printLog('Gagal membuat order, code: ${response.data}');
      }
    } catch (e) {
      printLog(e);
    }
  }
}
