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
          "amount": amount,
          "totalPrice": maxPrice,
          "address": address,
          "address_detail": note,
          "latitude_buyer": latitudeBuyer,
          "longitude_buyer": longitudeBuyer,
          "userID": userId
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

  Future<void> ongoingOrder({
    required String token,
    required String merchantId,
  }) async {
    try {
      Response response = await apiService.postApi(
        path: '${APIpath.ongoingOrder}/$merchantId',
        headers: {'Authorization': 'Bearer $token'},
        data: {"merchantID": merchantId},
      );
      if (response.statusCode == 200) {
        printLog(response.data);
      } else {
        printLog('Gagal, code: ${response.data}');
      }
    } catch (e) {
      printLog(e);
    }
  }

  /// BELOM DIPAKE
  Future<void> cancleOrder({
    required String token,
    required String orderId,
  }) async {
    try {
      Response response = await apiService.postApi(
        path: '${APIpath.ongoingOrder}/$orderId',
        headers: {'Authorization': 'Bearer $token'},
        data: {},
      );
      if (response.statusCode == 200) {
        printLog(response.data);
      } else {
        printLog('Gagal, code: ${response.data}');
      }
    } catch (e) {
      printLog(e);
    }
  }

  Future<void> completeOrder({
    required String token,
    required String orderId,
  }) async {
    try {
      Response response = await apiService.postApi(
        path: '${APIpath.completeOrder}/$orderId}',
        headers: {'Authorization': 'Bearer $token'},
        data: {},
      );
      if (response.statusCode == 200) {
        printLog(response.data);
      } else {
        printLog('Gagal, code: ${response.data}');
      }
    } catch (e) {
      printLog(e);
    }
  }

  Future<void> getOrderById({
    required String token,
    required String orderId,
  }) async {
    try {
      Response response = await apiService.getApi(
        path: '${APIpath.getOrderById}/$orderId}',
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        printLog(response.data);
      } else {
        printLog('Gagal, code: ${response.data}');
      }
    } catch (e) {
      printLog(e);
    }
  }

  Future<void> getOrderByUser({
    required String token,
    required String userId,
  }) async {
    try {
      Response response = await apiService.getApi(
        path: '${APIpath.getOrderByUser}/$userId}',
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        printLog(response.data);
      } else {
        printLog('Gagal, code: ${response.data}');
      }
    } catch (e) {
      printLog(e);
    }
  }

  Future<void> getOrderByMerchant({
    required String token,
    required String merchantId,
  }) async {
    try {
      Response response = await apiService.getApi(
        path: '${APIpath.getOrderByMerchant}/$merchantId}',
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        printLog(response.data);
      } else {
        printLog('Gagal, code: ${response.data}');
      }
    } catch (e) {
      printLog(e);
    }
  }
}
