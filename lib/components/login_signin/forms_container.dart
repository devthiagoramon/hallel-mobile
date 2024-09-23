import 'package:flutter/material.dart';

class FormContainerFields {
  final String label;
  final String hint;
  final String initialValue;
  final bool isPassword;
  final String? Function(String?) validator;
  final void Function(String) onChanged;

  FormContainerFields({
    required this.label,
    required this.hint,
    required this.initialValue,
    this.isPassword = false,
    required this.validator,
    required this.onChanged,
  });
}

class FormContainer extends StatefulWidget {
  final List<FormContainerFields> campos;
  final void Function() onButtonPressed;
  final GlobalKey<FormState> formKey;
  final String textButton;

  FormContainer(
      {required this.campos,
      required this.onButtonPressed,
      required this.formKey,
      required this.textButton});

  @override
  // ignore: library_private_types_in_public_api
  _FormContainerState createState() => _FormContainerState();
}

class _FormContainerState extends State<FormContainer> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var campo in widget.campos) {
      _controllers[campo.label] =
          TextEditingController(text: campo.initialValue);
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var textStyle = TextStyle(color: theme.colorScheme.onPrimary);
    var styleButton = FilledButton.styleFrom(
        backgroundColor: Colors.green[300], minimumSize: Size(300, 46));
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            ...widget.campos.map((campo) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campo.label,
                      style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _controllers[campo.label],
                      decoration: InputDecoration(
                          hintText: campo.hint,
                          hintStyle:
                              TextStyle(color: theme.colorScheme.onPrimary),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.5)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5)),
                          errorStyle: TextStyle(
                              color: Colors.red[500],
                              fontWeight: FontWeight.w600)),
                      cursorColor: theme.colorScheme.onPrimary,
                      cursorErrorColor: theme.colorScheme.error,
                      style: textStyle,
                      obscureText: campo.isPassword,
                      onChanged: campo.onChanged,
                      validator: campo.validator,
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              height: 40,
            ),
            FilledButton(
                style: styleButton,
                onPressed: () {
                  if (widget.formKey.currentState!.validate()) {
                    widget.onButtonPressed();
                  }
                },
                child: Text(
                  widget.textButton,
                  style: TextStyle(),
                ))
          ],
        ),
      ),
    );
  }
}
