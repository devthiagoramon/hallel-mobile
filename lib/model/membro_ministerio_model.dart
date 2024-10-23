import 'package:hallel/model/funcao_ministerio.dart';
import 'package:hallel/model/ministerio_model.dart';
import 'package:hallel/model/status_membro_ministerio.dart';
import 'package:hallel/model/user_model.dart';

class MembroMinisterio {
  String id = '';
  String membroId = '';
  User? membro;
  String ministerioId = '';
  Ministerio? ministerio;
  List<String> funcaoMinisterioIds = [];
  List<FuncaoMinisterio>? funcoesMinisterio;
  StatusMembroMinisterio? statusMembroMinisterio;

  MembroMinisterio();

  MembroMinisterio.simple({
    required this.id,
    required this.membroId,
    required this.ministerioId,
    required this.funcaoMinisterioIds,
  });

  MembroMinisterio convertByJsonToSimpleMembroMinisterio(dynamic data) {
    return MembroMinisterio.simple(
        id: data["id"] ?? "",
        membroId: data["membroId"] ?? "",
        ministerioId: data["ministerioId"] ?? "",
        funcaoMinisterioIds:
            List<String>.from(data["funcaoMinisterioIds"] ?? []));
  }

  MembroMinisterio convertJsonToCompleteMembroMinisterio(dynamic data) {
    MembroMinisterio membroMinisterio = MembroMinisterio();
    membroMinisterio.funcoesMinisterio =
        FuncaoMinisterio.convertJsonToListFuncaoMinisterio(
            data["funcaoMinisterio"]);
    membroMinisterio.membro = User.convertJsonToUser(data["membro"]);
    membroMinisterio.ministerio =
        Ministerio.convertToObjectByJson(data["ministerio"]);
    return membroMinisterio;
  }

  List<MembroMinisterio> convertJsonToListCompleteMembroMinisterio(
      dynamic list) {
    List<MembroMinisterio> listaMembroMinisterio = [];
    for (var obj in list) {
      listaMembroMinisterio.add(convertJsonToCompleteMembroMinisterio(obj));
    }
    return listaMembroMinisterio;
  }
}
