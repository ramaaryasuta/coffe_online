import 'package:coffeonline/utils/api.dart';
import 'package:coffeonline/utils/api_path.dart';
import 'package:coffeonline/utils/print_log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MerchantService with ChangeNotifier {
  final APIservice apiService = APIservice();
  Future<void> searchNearbyMerchant({
    required String token,
    required String lat,
    required String long,
    required int stock,
  }) async {
    try {
      Response response = await apiService.postApi(
        path: APIpath.nearbyMerchant,
        headers: {'Authorization': 'Bearer $token'},
        data: {
          "lat": lat,
          "long": long,
          "stock": stock,
        },
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

  Future<void> getAllMerchant({required String token}) async {
    try {
      Response response = await apiService.getApi(
        path: APIpath.getAllMerchant,
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

  Future<void> getMerchantById({
    required String token,
    required String id,
  }) async {
    try {
      Response response = await apiService.getApi(
        path: '${APIpath.getMerchantById}/$id',
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

  Future<void> updateMerchInfo({
    required String id,
    required String token,
    required String latitude,
    required String longitude,
    required String stock,
    required String price,
    required String status,
    // param kirim file untuk avatar
  }) async {
    try {
      Response response = await apiService.postApi(
        path: '${APIpath.updateMerchantInfo}$id',
        headers: {'Authorization': 'Bearer $token'},
        data: {
          "latitude": latitude,
          "longitude": longitude,
          "stock": stock,
          "price": price,
          "status": status,
        },
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
