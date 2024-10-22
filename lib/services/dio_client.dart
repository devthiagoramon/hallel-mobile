import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;
  static var tokenApi = "";
  static bool _loading = false;
  static var coordenadorTokenApi = "";

  DioClient() : _dio = Dio() {
    _dio.options.baseUrl = "http://10.0.2.2:80/api";
    _dio.options.connectTimeout = Duration(seconds: 5);
    _dio.options.receiveTimeout = Duration(seconds: 20);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        _loading = true;
        if (tokenApi.isNotEmpty) {
          options.headers["Authorization"] = tokenApi;
        }
        if (coordenadorTokenApi.isNotEmpty) {
          options.headers["coordenador-token"] = coordenadorTokenApi;
        }
        options.headers["Content-Type"] = "application/json";
        return handler.next(options); // Continue com a requisição
      },
      onResponse: (response, handler) {
        _loading = false;
        return handler.next(response); // Continua o processamento da resposta
      },
      onError: (e, handler) {
        _loading = false;
        return handler.next(e); // Continua o processamento do erro
      },
    ));

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

  Future<Response> put(String endpoint, {data}) async {
    return await _dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint) async {
    return await _dio.delete(endpoint);
  }

  void setTokenApi(String tokenReceived) {
    tokenApi = tokenReceived;
  }

  static void setTokenCoordenador(String tokenReceived) {
    coordenadorTokenApi = tokenReceived;
  }

  static bool isLoading() {
    return _loading;
  }
}
