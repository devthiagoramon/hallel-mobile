import 'package:dio/dio.dart';
import 'package:hallel/services/dio_client.dart';

class UserRoutesApi {
  Future<bool> validateTokenUserService(token) async {
    try {
      Response response =
          await DioClient().get("/public/home/isTokenValid?token=$token");
      return response.data;
    } catch (e) {
      return false;
    }
  }
}
