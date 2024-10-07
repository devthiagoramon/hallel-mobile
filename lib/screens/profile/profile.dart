import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hallel/model/user_model.dart';
import 'package:hallel/services/dio_client.dart';
import 'package:hallel/store/provider.dart';
import 'package:hallel/utils/image_picker.dart';
import 'package:hallel/utils/utils.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    setupListener(ref);
  }

  void setupListener(WidgetRef ref) {
    final nameUser = ref.read(userProvider).nome;
    log('User name $nameUser', name: "ProfileScreen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfilePicture(
              profilePicture: ref.read(userProvider).image,
            ),
            ProfileInfosContainer()
          ],
        ),
      ),
    );
  }
}

class ProfileInfosContainer extends ConsumerWidget {
  const ProfileInfosContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userObject = ref.read(userProvider);

    final titleStyle = TextStyle(fontSize: 28, fontWeight: FontWeight.bold);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Informações pessoais",
            style: titleStyle,
          ),
          Divider(),
          ModalsTextFieldsProfile(
              props: ModalsTextFieldsProfileProps(
                  title: "Nome",
                  name: "nome",
                  value: userObject.nome,
                  hint: "Digite o seu nome!")),
          ModalsTextFieldsProfile(
              props: ModalsTextFieldsProfileProps(
                  title: "E-mail",
                  name: "email",
                  value: userObject.email,
                  hint: "email@gmail.com")),
          ModalsTextFieldsProfile(
            props: ModalsTextFieldsProfileProps(
                title: "CPF",
                name: "cpf",
                value: userObject.cpf == ""
                    ? "Nenhum CPF cadastrado"
                    : userObject.cpf,
                hint: "111-222-333-44"),
            textInputType: TextInputType.number,
            maskedTextController: MaskedTextController(
                mask: "000.000.000-00", text: userObject.cpf),
          ),
          ModalsTextFieldsProfile(
              props: ModalsTextFieldsProfileProps(
                  title: "Data de nascimento",
                  name: "dataNascimento",
                  value: DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(userObject.dataNascimento)),
                  hint: "11/11/2011"),
              textInputType: TextInputType.number,
              maskedTextController: MaskedTextController(
                  mask: "00/00/0000",
                  text: DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(userObject.dataNascimento)))),
          ModalsTextFieldsProfile(
              props: ModalsTextFieldsProfileProps(
                  title: "Telefone",
                  name: "telefone",
                  value: userObject.telefone == ""
                      ? "Nenhum telefone cadastrado"
                      : userObject.telefone,
                  hint: "(92) 91234-5678"),
              textInputType: TextInputType.number,
              maskedTextController: MaskedTextController(
                  mask: "(00) 00000-0000",
                  text: userObject.telefone == "" ? "" : userObject.telefone))
        ],
      ),
    );
  }
}

class ModalsTextFieldsProfileProps {
  ModalsTextFieldsProfileProps(
      {required this.title,
      required this.name,
      required this.value,
      required this.hint});

  String title;
  String name;
  String value;
  String hint;
}

class ModalsTextFieldsProfile extends ConsumerStatefulWidget {
  final ModalsTextFieldsProfileProps props;
  final MaskedTextController? maskedTextController;
  final TextInputType? textInputType;

  ModalsTextFieldsProfile(
      {super.key,
      required this.props,
      this.maskedTextController,
      this.textInputType});

  @override
  ConsumerState<ModalsTextFieldsProfile> createState() =>
      _ModalsTextFieldsProfileState();
}

class _ModalsTextFieldsProfileState
    extends ConsumerState<ModalsTextFieldsProfile> {
  bool _isEditable = false;
  String _editableValue = "";
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _editableValue = widget.props.value;
      _controller = TextEditingController(text: _editableValue);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void changeToEdit() {
    setState(() {
      _isEditable = true;
    });
  }

  void cancelEdit() {
    setState(() {
      _isEditable = false;
      _editableValue = widget.props.value;
    });
  }

  Future<void> sendRequest() async {
    // TODO: IMPLEMENT UPDATE PERSONAL INFOS
    User oldUser = ref.read(userProvider);
    User updatedUser;

    switch (widget.props.name) {
      case "nome":
        updatedUser = oldUser.copyWith(nome: _editableValue);
        break;
      case "dataNascimento":
        DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(_editableValue);
        updatedUser =
            oldUser.copyWith(dataNascimento: parsedDate.toIso8601String());
        break;
      case "email":
        updatedUser = oldUser.copyWith(email: _editableValue);
        break;
      case "cpf":
        updatedUser = oldUser.copyWith(cpf: _editableValue);
        break;
      case "telefone":
        updatedUser = oldUser.copyWith(telefone: _editableValue);
        break;
      default:
        throw ArgumentError('Campo desconhecido: ${widget.props.name}');
    }
    final body = jsonEncode({
      'id': updatedUser.id,
      'nome': updatedUser.nome,
      'dataNascimento': updatedUser.dataNascimento,
      'email': updatedUser.email,
      'image': updatedUser.image,
      'cpf': updatedUser.cpf,
      'telefone': updatedUser.telefone,
    });
    try {
      Response response =
          await DioClient().patch("/membros/perfil", data: body);
      if (response.data != null) {
        ref.read(userProvider.notifier).updateUserWithUserObject(updatedUser);
        if (!mounted) return;
        setState(() {
          _isEditable = false;
          _editableValue = _editableValue;
          widget.props.value = _editableValue;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Usuario atualizado com sucesso"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      log(e.toString(), name: "ProfileScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.w600);
    final valueStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.normal);

    return _isEditable
        ? Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.props.title,
                    style: labelStyle,
                  ),
                  IconButton(
                      iconSize: 24,
                      onPressed: cancelEdit,
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ))
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.maskedTextController ?? _controller,
                      keyboardType: widget.textInputType ?? TextInputType.text,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: widget.props.hint),
                      onChanged: (value) {
                        setState(() {
                          _editableValue = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: sendRequest,
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ))
                ],
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.props.title,
                    style: labelStyle,
                  ),
                  IconButton(
                      iconSize: 24,
                      onPressed: changeToEdit,
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ))
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                widget.props.value,
                style: valueStyle,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              )
            ],
          );
  }
}

class ProfilePicture extends ConsumerStatefulWidget {
  final String? profilePicture;
  const ProfilePicture({super.key, required this.profilePicture});

  @override
  ConsumerState<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends ConsumerState<ProfilePicture> {
  String? actualProfilePicture = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      actualProfilePicture = widget.profilePicture;
    });
  }

  Future<void> editPhotoUser(BuildContext context, WidgetRef ref) async {
    String? image = await ImagePickerUtil().pickImageAndConvertToBase64();

    User user = ref.read(userProvider);
    User updatedUser = user.copyWith(image: image);

    final body = jsonEncode({
      'id': updatedUser.id,
      'nome': updatedUser.nome,
      'dataNascimento': updatedUser.dataNascimento,
      'email': updatedUser.email,
      'image': updatedUser.image,
      'cpf': updatedUser.cpf,
      'telefone': updatedUser.telefone,
    });
    try {
      Response response =
          await DioClient().patch("/membros/perfil", data: body);
      if (response.data != null) {
        ref.read(userProvider.notifier).updateUserWithUserObject(updatedUser);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Imagem do usuário atualizada com sucesso!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      log(e.toString(), name: "ProfileScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 24),
          Stack(
            children: [
              actualProfilePicture != null && actualProfilePicture!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Image.memory(
                        AppUtils().getImageByBase64(actualProfilePicture ?? ""),
                        width: 250,
                        height: 250,
                      ),
                    )
                  : SizedBox(),
              Positioned(
                right: 10,
                top: 10,
                child: Tooltip(
                  message: "Editar foto de perfil",
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                          color: Colors.blue,
                          child: IconButton(
                              onPressed: () => editPhotoUser(context, ref),
                              iconSize: 32,
                              color: Colors.white,
                              icon: Icon(Icons.edit)))),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
