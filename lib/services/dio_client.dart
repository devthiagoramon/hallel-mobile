import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;
  static var tokenApi = "";

  DioClient() : _dio = Dio() {
    _dio.options.baseUrl = "http://10.0.2.2:8080/api";
    _dio.options.connectTimeout = Duration(seconds: 5);
    _dio.options.receiveTimeout = Duration(seconds: 3);
  }

  Future<Response<T>> get<T>(String endpoint) async {
    return await _dio.get(endpoint);
  }

  Future<Response> post(String endpoint, {data}) async {
    return await _dio.post(endpoint, data: data);
  }

  void setTokenApi(String tokenReceived) {
    tokenApi = tokenReceived;
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (tokenApi.isNotEmpty) {
        options.headers["Authorization"] = tokenApi;
      }
      return handler.next(options);
    }));
  }
}
