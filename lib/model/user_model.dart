class User {
  User(
      {required this.id,
      required this.nome,
      required this.dataNascimento,
      required this.email,
      required this.status,
      required this.image,
      required this.cpf,
      required this.telefone});

  String id;
  String nome;
  String dataNascimento;
  String email;
  String status;
  String image;
  String cpf;
  String telefone;

  User copyWith({
    String? id,
    String? nome,
    String? dataNascimento,
    String? email,
    String? status,
    String? image,
    String? cpf,
    String? telefone,
  }) {
    return User(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      email: email ?? this.email,
      status: status ?? this.status,
      image: image ?? this.image,
      cpf: cpf ?? this.cpf,
      telefone: telefone ?? this.telefone,
    );
  }
}
