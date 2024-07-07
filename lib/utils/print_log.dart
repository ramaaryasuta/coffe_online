import 'dart:convert';

import 'package:flutter/foundation.dart';

printLog(dynamic output, {bool isError = false}) {
  final color = isError ? '31m' : '33m';
  try {
    debugPrint('\x1B[$color${jsonEncode(output)}\x1B[0m');
  } catch (_) {
    final value = output.toString();
    int maxLogSize = 1000;
    for (int i = 0; i <= value.length / maxLogSize; i++) {
      int start = i * maxLogSize;
      int end = (i + 1) * maxLogSize;
      end = end > value.length ? value.length : end;
      if (kDebugMode) {
        print('\x1B[$color${value.substring(start, end)}\x1B[0m');
      }
    }
  }
}
