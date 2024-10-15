class Ministerio {
  String? id;
  String? nome;
  String? coordenadorId;
  String? viceCoordenadorId;
  String? descricao;
  String? imagem;
  List<String> objetivos;

  Ministerio(
      {required this.id,
      required this.nome,
      required this.coordenadorId,
      required this.viceCoordenadorId,
      required this.descricao,
      required this.imagem,
      required this.objetivos});

  static Ministerio convertToObjectByJson(dynamic obj) {
    return Ministerio(
        id: obj['id'],
        nome: obj['nome'],
        coordenadorId: obj['coordenadorId'],
        viceCoordenadorId: obj['viceCoordenadorId'],
        descricao: obj['descricao'],
        imagem: obj['imagem'],
        objetivos: List<String>.from(obj['objetivos'] ?? []));
  }

  static List<Ministerio> convertToListObjectByJson(dynamic list) {
    List<Ministerio> listaMinisterio = [];
    for (var obj in list) {
      listaMinisterio.add(convertToObjectByJson(obj));
    }
    return listaMinisterio;
  }
}
