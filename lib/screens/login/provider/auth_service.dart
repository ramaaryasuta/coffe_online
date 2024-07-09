import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/print_log.dart';
import '../../../utils/api_path.dart';
import '../../../utils/api.dart';
import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  AuthService() {
    _loadToken();
  }

  final APIservice apiService = APIservice();

  String token = '';
  int? userId;
  String? typeUser;
  UserDataModel? userData;

  /// handling register cause 201 and 409 have same key 'message'
  bool successRegis = false;
  bool isLogin = false;

  void _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    createFCMToken();
    if (token.isNotEmpty) {
      decodeToken(token);
      decodeType(token);
    } else {
      printLog('Gagal mendapatkan token');
    }
    notifyListeners();
  }

  void decodeToken(String token) {
    try {
      final decodeT = JWT.decode(token);
      printLog(decodeT.payload['userId']);
      userId = decodeT.payload['userId'];
      notifyListeners();
    } catch (e) {
      printLog(e);
    }
  }

  void decodeType(String token) {
    try {
      final decodeType = JWT.decode(token);
      printLog(decodeType.payload['type']);
      typeUser = decodeType.payload['type'];
      notifyListeners();
    } catch (e) {
      printLog(e);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await apiService.postApi(
        path: APIpath.login,
        data: {'email': email, 'password': password},
      );
      printLog(response.data);
      if (response.statusCode == 200) {
        isLogin = true;
        token = response.data['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        decodeToken(token);
        notifyListeners();
      } else if (response.statusCode != 200) {
        printLog('Gagal Login, code: ${response.statusCode}');
      }
    } catch (e) {
      printLog(e);
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    token = '';
    userData = null;
    userId = null;
    typeUser = null;
    printLog('Berhasil Logout');
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String type,
    required String fcmToken,
  }) async {
    try {
      Response response =
          await apiService.postApi(path: APIpath.register, data: {
        'name': name,
        'email': email,
        'password': password,
        'phone_number': phoneNumber,
        'type': type,
        'token': fcmToken
      });
      if (response.statusCode == 201) {
        successRegis = true;
        notifyListeners();
      } else {
        printLog('Gagal Registrasi, code: ${response.statusCode}');
      }
    } catch (e) {
      printLog(e);
    }
  }

  Future<void> getUserData(int id) async {
    try {
      Response response = await apiService.getApi(
        path: '${APIpath.getUserData}/$id',
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        userData = UserDataModel.fromJson(response.data);
        printLog(userData!);
        notifyListeners();
      } else {
        printLog(
          'Gagal mendapatkan data pengguna, code: ${response.statusCode}',
        );
      }
    } catch (e) {
      printLog(e);
    }
  }

  Future<String> createFCMToken() async {
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    String? token = await fcm.getToken();
    printLog(token);
    return token ?? '';
  }
}
