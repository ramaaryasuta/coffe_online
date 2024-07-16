import 'package:coffeonline/screens/home/model/riwayat_model.dart';
import 'package:coffeonline/screens/orders/models/ongoing_model.dart';
import 'package:coffeonline/screens/orders/models/order_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api.dart';
import '../../../utils/api_path.dart';
import '../../../utils/print_log.dart';

class OrderService with ChangeNotifier {
  final APIservice apiService = APIservice();
  final APIservice? apiServiceOrder;

  OrderService({this.apiServiceOrder});

  bool successOrder = false;
  OrderResponse? orderResponse;
  OrderResponse? orderRequestResponse;
  OngoingResponse? ongoingResponse;
  late int orderRequestId;

  List<HistoryModel> historyOrder = [];

  double myLat = 0.0;
  double myLong = 0.0;

  int? amountCoffe;
  String? maxPrice;
  String? address;
  String? note;

  Future<void> saveRequest({required String id}) async {
    orderRequestId = int.parse(id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('orderRequestId', orderRequestId);
    int idOrder = await prefs.getInt('orderRequestId')!;
    printLog('save id: $idOrder');
    notifyListeners();
  }

  Future<void> resetOrderRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('orderRequestId');
    orderRequestResponse = null;
    notifyListeners();
  }

  Future<void> getOrderRequested({required String token}) async {
    try {
      printLog("getorderrequest");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int idOrder = await prefs.getInt('orderRequestId')!;
      printLog("getOrderRequested ID: $idOrder");
      Response response = await apiService.getApi(
          path: '${APIpath.getOrderById}/$idOrder',
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        orderRequestResponse = OrderResponse.fromJson(response.data);
        if (orderRequestResponse!.merchantId != null) {
          orderRequestResponse = null;
          await prefs.remove('orderRequestId');
        }
        printLog(orderRequestResponse);
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      printLog(e);
    }
  }

  void saveOrderData({
    required int amountCoffe,
    required String maxPrice,
    required String address,
    required String note,
  }) {
    this.amountCoffe = amountCoffe;
    this.maxPrice = maxPrice;
    this.address = address;
    this.note = note;
    printLog('Succes');
    notifyListeners();
  }

  void saveMyLatLang(double lat, double long) {
    myLat = lat;
    myLong = long;
    notifyListeners();
  }

  Future<void> createOrder({
    required String token,
    required int amount,
    required String maxPrice,
    required String address,
    required String note,
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
          "latitude_buyer": myLat,
          "longitude_buyer": myLong,
          "userID": userId
        },
      );
      if (response.statusCode == 201) {
        successOrder = true;
        printLog(response.data);
        orderResponse = OrderResponse.fromJson(response.data);
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
    required String orderId,
  }) async {
    try {
      Response response = await apiService.postApi(
        path: '${APIpath.ongoingOrder}/$orderId',
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
        path: '${APIpath.getOrderById}/$orderId',
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        printLog(response.data);
        ongoingResponse = OngoingResponse.fromJson(response.data);
        printLog(ongoingResponse);
        notifyListeners();
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
        historyOrder.clear();
        var data = response.data as List;
        historyOrder = await data.map((e) => HistoryModel.fromJson(e)).toList();
        printLog('BERSHASIL MENGAMBIL Riwayat User');
        notifyListeners();
      } else {
        printLog('Gagal, code: ${response.data}');
      }
    } catch (e) {
      printLog(e);
    }
  }

  Future<void> getOrderByMerchant({
    required String token,
    required int? merchantId,
  }) async {
    try {
      printLog("getOrderMerchant");
      Response response = await apiService.getApi(
        path: '${APIpath.getOrderByMerchant}/$merchantId}',
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        var data = response.data as List;
        historyOrder = data.map((e) => HistoryModel.fromJson(e)).toList();
        printLog('panjang list order: ${historyOrder.length}');
        notifyListeners();
      } else {
        printLog('Gagal, code: ${response.data}');
      }
    } catch (e) {
      printLog("error: $e");
    }
  }
}
