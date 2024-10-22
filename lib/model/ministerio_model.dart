import 'package:hallel/model/user_model.dart';

class Ministerio {
  String? id;
  String? nome;
  String? coordenadorId;
  User? coordenador;
  String? viceCoordenadorId;
  User? viceCoordenador;
  String? descricao;
  String? imagem;
  List<String>? objetivos;

  Ministerio.empty();

  Ministerio(
      {required this.id,
      required this.nome,
      required this.coordenadorId,
      this.coordenador,
      required this.viceCoordenadorId,
      this.viceCoordenador,
      required this.descricao,
      required this.imagem,
      required this.objetivos});

  static Ministerio convertToObjectByJson(dynamic obj) {
    if (obj != []) {
      return Ministerio(
          id: obj['id'],
          nome: obj['nome'],
          coordenadorId: obj['coordenadorId'] ?? "",
          coordenador: obj['coordenador'] != null
              ? User.convertJsonToUser(obj['coordenador'])
              : null,
          viceCoordenadorId: obj['viceCoordenadorId'] ?? "",
          viceCoordenador: obj['viceCoordenador'] != null
              ? User.convertJsonToUser(obj['viceCoordenador'])
              : null,
          descricao: obj['descricao'],
          imagem: obj['imagem'],
          objetivos: List<String>.from(obj['objetivos'] ?? []));
    } else {
      return Ministerio.empty();
    }
  }

  static List<Ministerio> convertToListObjectByJson(dynamic list) {
    List<Ministerio> listaMinisterio = [];
    for (var obj in list) {
      listaMinisterio.add(convertToObjectByJson(obj));
    }
    return listaMinisterio;
  }
}
