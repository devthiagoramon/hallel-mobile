import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hallel/model/user_model.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier()
      : super(User(
            id: "",
            nome: "",
            dataNascimento: "",
            email: "",
            status: "",
            image: "",
            cpf: "",
            telefone: ""));

  void loginAction(dynamic loginResponse) {
    state = User(
        id: loginResponse['id'] ?? "",
        nome: loginResponse['nome'] ?? "",
        dataNascimento: loginResponse["dataNascimento"] ?? "",
        email: loginResponse["email"] ?? "",
        status: loginResponse["status"] ?? "",
        image: loginResponse["image"] ?? "",
        cpf: loginResponse["cpf"] ?? "",
        telefone: loginResponse["telefone"] ?? "");
  }

  void updateUserWithUserObject(User user) {
    state = user;
  }
}
