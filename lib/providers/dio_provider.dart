import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/index.dart';

class DioProvider extends GetxService {
  final isProduction = const bool.fromEnvironment('dart.vm.product');
  var dio = Dio();
  @override
  void onInit() {
    dio.options.baseUrl = isProduction
        // ? 'https://lawyernestjs-production.up.railway.app'
        // : 'https://lawyernestjs-production.up.railway.app';

    // ? 'http://192.168.1.2:5050'
    // : 'http://192.168.1.2:5050';
    ? 'http://192.168.1.14:5050'
    : 'http://192.168.1.14:5050';

    dio.interceptors.addAll(
      [
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // get token from storage
            final token =
                Get.find<SharedPreferences>().getString(StorageKeys.token.name);
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            } else {}
            return handler.next(options);
          },
        ),
        // RetryOnConnectionChangeInterceptor()
        // LogInterceptor(responseBody: true),
      ],
    );
    super.onInit();
  }

  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on Exception {
      rethrow;
    }
  }

  Future<dynamic> post(String path,
      {Map<String, dynamic>? data, Options? options}) async {
    try {
      final response = await dio.post(path, data: data, options: options);

      return response.data;
    } on Exception {
      rethrow;
    }
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.put(path, data: data);
      return response.data;
    } on Exception {
      rethrow;
    }
  }

  Future<dynamic> patch(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.patch(path, data: data);
      return response.data;
    } on Exception {
      rethrow;
    }
  }

  Future<dynamic> delete(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.delete(path, data: data);
      return response.data;
    } on Exception {
      rethrow;
    }
  }
}
