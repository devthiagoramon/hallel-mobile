class FuncaoMinisterio {
  String id;
  String ministerioId;
  String nome;
  String? descricao;
  String? icone;
  String? cor;

  FuncaoMinisterio.empty(
      {this.id = "", this.ministerioId = "", this.nome = ""});

  FuncaoMinisterio({
    required this.id,
    required this.ministerioId,
    required this.nome,
    required this.descricao,
    required this.icone,
    required this.cor,
  });

  static FuncaoMinisterio convertJsonToFuncaoMinisterio(dynamic data) {
    return FuncaoMinisterio(
        id: data["id"] ?? "",
        ministerioId: data["ministerioId"] ?? "",
        nome: data["nome"] ?? "",
        descricao: data["descricao"],
        icone: data["icone"],
        cor: data["cor"]);
  }

  static List<FuncaoMinisterio> convertJsonToListFuncaoMinisterio(
      dynamic list) {
    List<FuncaoMinisterio> listaMinisterio = [];
    for (var obj in list) {
      listaMinisterio.add(convertJsonToFuncaoMinisterio(obj));
    }
    return listaMinisterio;
  }
}
