import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hallel/model/dtos/funcao_ministerio_dto.dart';
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
      return false;
    }
  }
}
