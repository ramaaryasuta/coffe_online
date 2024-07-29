import 'dart:convert';
import 'package:coffeonline/utils/api.dart';
import 'package:coffeonline/utils/api_path.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CoffeeService with ChangeNotifier {
  final APIservice apiService = APIservice();

  List<Map<String, dynamic>> coffeeData = []; // Update type

  Future<void> getCoffee() async {
    try {
      final response = await apiService.getApi(path: APIpath.getCoffee);

      // Ensure response.data is a List<dynamic>
      if (response.data is List<dynamic>) {
        coffeeData = (response.data as List<dynamic>)
            .map((item) => item as Map<String, dynamic>)
            .toList();
        notifyListeners();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print('Error fetching coffee data: $e');
    }
  }
}
