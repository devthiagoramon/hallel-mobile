import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hallel/model/ministerio_model.dart';
import 'package:hallel/services/dio_client.dart';

class MinisterioService {
  Future<Ministerio> listMinisterioWithDetails(String idMinisterio) async {
    try {
      Response response =
          await DioClient().get("/public/ministerio/id/$idMinisterio");
      return Ministerio.convertToObjectByJson(response.data);
    } catch (e) {
      log(e.toString(), name: "MinisterioServiceAPI");
      return Ministerio.empty();
    }
  }
}
