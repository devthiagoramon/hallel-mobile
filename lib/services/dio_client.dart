import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;
  static var tokenApi = "";

  DioClient() : _dio = Dio() {
    _dio.options.baseUrl = "http://10.0.2.2:80/api";
    _dio.options.connectTimeout = Duration(seconds: 5);
    _dio.options.receiveTimeout = Duration(seconds: 20);

    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (tokenApi.isNotEmpty) {
        options.headers["Authorization"] = 'Bearer $tokenApi';
      }
      options.headers["Content-Type"] = "application/json";
      return handler.next(options); // Continue com a requisição
    }));

    // _dio.interceptors.add(LogInterceptor(
    //     request: true,
    //     requestBody: true,
    //     requestHeader: true,
    //     responseBody: true,
    //     error: true,
    //     responseHeader: true,
    //     logPrint: (object) {
    //       log(object.toString(), name: "LOG INTERCEPTOR");
    //     }));
  }

  Future<Response<T>> get<T>(String endpoint) async {
    return await _dio.get(endpoint);
  }

  Future<Response> post(String endpoint, {data}) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> patch(String endpoint, {data}) async {
    return await _dio.patch(endpoint, data: data);
  }

  void setTokenApi(String tokenReceived) {
    tokenApi = tokenReceived;
  }
}
