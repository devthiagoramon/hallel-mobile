import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hallel/model/ministerio_model.dart';
import 'package:hallel/model/status_membro_ministerio.dart';
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

  Future<StatusMembroMinisterio?> listStatusMembroMinisterioInMinisterio(
      String idMinisterio, String idMembro) async {
    try {
      StatusMembroMinisterio status;
      Response response = await DioClient()
          .get("/membros/ministerio/status/$idMinisterio/$idMembro");
      switch (response.toString()) {
        case "MEMBRO":
          status = StatusMembroMinisterio.membro;
          break;
        case "COORDENADOR":
          status = StatusMembroMinisterio.coordenador;
          break;
        case "VICE_COORDENADOR":
          status = StatusMembroMinisterio.viceCoordenador;
          break;
        default:
          status = StatusMembroMinisterio.membro;
      }
      return status;
    } catch (e) {
      log(e.toString(), name: "MembroMinisterioServiceAPI");
      return null;
    }
  }

  Future<String?> getTokenCoordenador(
      String ministerioId, String membroId) async {
    try {
      Response response = await DioClient().get(
          "/membros/ministerio/token?ministerioId=$ministerioId&membroId=$membroId");
      return response.data;
    } catch (e) {
      log(e.toString(), name: "MembroMinisterioServiceAPI");
      return null;
    }
  }
}
