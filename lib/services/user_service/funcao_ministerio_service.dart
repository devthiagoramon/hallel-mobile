import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hallel/model/dtos/funcao_ministerio_dto.dart';
import 'package:hallel/model/funcao_ministerio.dart';
import 'package:hallel/services/dio_client.dart';

class FuncaoMinisterioServiceAPI {
  Future<bool> createFuncao(FuncaoMinisterioDto data) async {
    try {
      final body = jsonEncode({
        "ministerioId": data.ministerioId,
        "nome": data.nome,
        "descricao": data.descricao,
        "icone": data.icone,
        "cor": data.cor,
      });
      Response response = await DioClient()
          .post("/membros/ministerio/coordenador/funcao", data: body);
      return true;
    } catch (e) {
      log(e.toString(), name: "FuncaoMinisterioAPI");
      throw Exception("Erro ao adicionar a função, tente novamente!");
    }
  }

  Future<bool> editFuncao(
      String idFuncaoMinisterio, FuncaoMinisterioDto data) async {
    try {
      final body = jsonEncode({
        "ministerioId": data.ministerioId,
        "nome": data.nome,
        "descricao": data.descricao,
        "icone": data.icone,
        "cor": data.cor,
      });
      await DioClient().put(
          "/membros/ministerio/coordenador/funcao/$idFuncaoMinisterio",
          data: body);
      return true;
    } catch (e) {
      log(e.toString(), name: "FuncaoMinisteiroAPI");
      throw Exception("Erro ao editar a função, tente novamente!");
    }
  }

  Future<List<FuncaoMinisterio>> listFuncaoMinisterioAPI(
      String idMinisterio) async {
    try {
      Response response = await DioClient().get(
          "/membros/ministerio/coordenador/funcao/ministerio/$idMinisterio");
      return FuncaoMinisterio.convertJsonToListFuncaoMinisterio(response.data);
    } catch (e) {
      log(e.toString(), name: "FuncaoMinisterioServiceAPI");
      return [];
    }
  }
}
