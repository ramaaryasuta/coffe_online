import 'package:coffeonline/utils/print_log.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIservice {
  final dio = Dio();

  APIservice() {
    dio.options.baseUrl = dotenv.env['BASEURL'].toString();
    dio.options.headers = {'Content-Type': 'application/json'};
  }

  Future<Response> postApi({
    required String path,
    required Map<String, dynamic> data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      Response response = await dio.post(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      Response response = e.response!;
      printLog(e);
      return response;
    }
  }

  Future<Response> getApi({
    required String path,
    Map<String, dynamic>? headers,
  }) async {
    try {
      Response response = await dio.get(
        path,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      Response response = e.response!;
      printLog(e);
      return response;
    }
  }
}
