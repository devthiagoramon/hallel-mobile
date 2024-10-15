import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hallel/model/ministerio_model.dart';
import 'package:hallel/services/dio_client.dart';

class MembroMinisterioServiceAPI {
  Future<List<Ministerio>> listMinisterioThatMembroParticipate(
      String idMembro) async {
    try {
      Response response = await DioClient()
          .get("/membros/ministerio/membroParticipate/$idMembro");
      return Ministerio.convertToListObjectByJson(response.data);
    } catch (e) {
      log(e.toString(), name: "MembroMinisterioServiceAPI");
      return [];
    }
  }
}
