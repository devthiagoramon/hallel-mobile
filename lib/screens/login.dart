import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hallel/components/login_signin/forms_container.dart';
import 'package:hallel/components/login_signin/logo_container.dart';
import 'package:hallel/services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: ContainerLogin(),
    );
  }
}

class ContainerLogin extends StatefulWidget {
  const ContainerLogin({
    super.key,
  });

  @override
  State<ContainerLogin> createState() => _ContainerLoginState();
}

class _ContainerLoginState extends State<ContainerLogin> {
  final _formKey = GlobalKey<FormState>();

  // Estados para armazenar os valores dos campos
  Map<String, String> formValues = {
    'Email': '',
    'Senha': '',
  };

  // Função para atualizar os valores do formulário
  void updateFormValue(String field, String value) {
    setState(() {
      formValues[field] = value;
    });
  }

  void sendRequest() async {
    log("Login request: $formValues", name: "LoginScreen");

    dynamic dto = {'email': formValues['Email'], 'senha': formValues['Senha']};
    try {
      Response response = await DioClient().post("/public/login", data: dto);
      String token = response.data["token"];
      DioClient().setTokenApi(token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("tokenApi", token);
      if (!mounted) return;
      context.go("/home");
    } catch (e) {
      log(e.toString(), name: "LoginScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        SingleChildScrollView(
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
                  "LOGIN",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: theme.colorScheme.onPrimary),
                ),
              ),
              FormContainer(
                  formKey: _formKey,
                  onButtonPressed: sendRequest,
                  textButton: "ENTRAR",
                  campos: [
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
                        onChanged: (value) => updateFormValue('Email', value)),
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
                        onChanged: (value) => updateFormValue('Senha', value))
                  ])
            ],
          ),
        ),
        Positioned(
            top: 40,
            left: 10,
            child: IconButton(
                onPressed: () {
                  GoRouter.of(context).go("/");
                },
                iconSize: 38,
                color: Colors.white,
                icon: Icon(Icons.chevron_left)))
      ],
    );
  }
}
