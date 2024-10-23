import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hallel/model/membro_ministerio_model.dart';
import 'package:hallel/services/dio_client.dart';

class CoordenadorMinisterioService {
  Future<List<MembroMinisterio>> listMembrosMinisterioOfMinisterio(
      String ministerioId) async {
    try {
      Response response = await DioClient().get(
          "/membros/ministerio/coordenador/membroMinisterio/list/$ministerioId");
      return MembroMinisterio()
          .convertJsonToListCompleteMembroMinisterio(response.data);
    } catch (e) {
      log(e.toString(), name: "MembroMinisterioService");
      throw Exception("Can't list membros of ministerio id $ministerioId");
    }
  }
}
