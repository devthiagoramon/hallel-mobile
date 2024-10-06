import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hallel/store/provider.dart';
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
          children: [ProfilePicture(), ProfileInfosContainer()],
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
                  hint: "111-222-333-44")),
          ModalsTextFieldsProfile(
              props: ModalsTextFieldsProfileProps(
                  title: "Data de nascimento",
                  name: "dataNascimento",
                  value: DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(userObject.dataNascimento)),
                  hint: "11/11/2011")),
          ModalsTextFieldsProfile(
              props: ModalsTextFieldsProfileProps(
                  title: "Telefone",
                  name: "telefone",
                  value: userObject.telefone == ""
                      ? "Nenhum telefone cadastrado"
                      : userObject.telefone,
                  hint: "(92) 91234-5678"))
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

class ModalsTextFieldsProfile extends StatefulWidget {
  final ModalsTextFieldsProfileProps props;

  ModalsTextFieldsProfile({super.key, required this.props});

  @override
  State<ModalsTextFieldsProfile> createState() =>
      _ModalsTextFieldsProfileState();
}

class _ModalsTextFieldsProfileState extends State<ModalsTextFieldsProfile> {
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
                      controller: _controller,
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

class ProfilePicture extends ConsumerWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userObject = ref.read(userProvider);
    return Center(
      child: Column(
        children: [
          SizedBox(height: 24),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Image.memory(
                  AppUtils().getImageByBase64(userObject.image),
                  width: 250,
                  height: 250,
                ),
              ),
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
                              onPressed: () {},
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
