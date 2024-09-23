import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hallel/components/login_signin/forms_container.dart';
import 'package:hallel/components/login_signin/logo_container.dart';
import 'package:hallel/services/dio_client.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: ContainerSignIn(),
    );
  }
}

class ContainerSignIn extends StatefulWidget {
  const ContainerSignIn({
    super.key,
  });

  @override
  State<ContainerSignIn> createState() => _ContainerSignInState();
}

class _ContainerSignInState extends State<ContainerSignIn> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> formValues = {
    'Nome': '',
    'Email': '',
    'Senha': '',
    'ConfirmSenha': '',
  };

  void updateFormsValue(String name, String value) {
    setState(() {
      formValues[name] = value;
    });
  }

  void sendRequest() async {
    log("SignIn request $formValues", name: "SignInScreen");
    if (formValues["Senha"] != formValues["ConfirmSenha"]) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Senhas incompatíveis, tente novamente!"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    dynamic dto = {
      'nome': formValues["Nome"],
      'senha': formValues["Senha"],
      'email': formValues["Email"]
    };
    try {
      Response response =
          await DioClient().post("/public/cadastrar", data: dto);
      if (!mounted) return;
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erro ao cadastrar, tente novamente!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
        return;
      }
      Navigator.popAndPushNamed(context, "/login");
    } catch (e) {
      log(e.toString(), name: "SignInScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LogoContainer(),
          SizedBox(
            height: 54,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "CADASTRO",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: theme.colorScheme.onPrimary),
            ),
          ),
          FormContainer(
              formKey: _formKey,
              onButtonPressed: sendRequest,
              textButton: "CADASTRAR",
              campos: [
                FormContainerFields(
                    label: "Nome",
                    hint: "Digite o seu nome",
                    initialValue: formValues['Nome']!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o seu nome';
                      }
                      return null;
                    },
                    onChanged: (value) => updateFormsValue('Nome', value)),
                FormContainerFields(
                    label: "E-mail",
                    hint: "Digite o seu e-mail",
                    initialValue: formValues['Email']!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o e-mail';
                      }
                      return null;
                    },
                    onChanged: (value) => updateFormsValue('Email', value)),
                FormContainerFields(
                    label: "Senha",
                    hint: "Digite a sua senha",
                    initialValue: formValues['Senha']!,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a sua senha';
                      }
                      return null;
                    },
                    onChanged: (value) => updateFormsValue('Senha', value)),
                FormContainerFields(
                    label: "Confirmar senha",
                    hint: "Confirme a sua senha",
                    initialValue: formValues['ConfirmSenha']!,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme a sua senha';
                      }
                      return null;
                    },
                    onChanged: (value) =>
                        updateFormsValue('ConfirmSenha', value))
              ])
        ],
      ),
    );
  }
}
