class FuncaoMinisterioDto {
  String ministerioId;
  String nome;
  String descricao;
  String? icone;
  String? cor;

  FuncaoMinisterioDto(
      {required this.ministerioId,
      required this.nome,
      required this.descricao,
      this.cor,
      this.icone});
}
