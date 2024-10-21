import 'package:flutter/material.dart';

class TextFormFieldH extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  // final void Function(String) onChanged;
  final String? Function(String?) validator;
  final int? minLines;
  final int? maxLines;

  const TextFormFieldH(
      {super.key,
      required this.controller,
      this.hint,
      // required this.onChanged,
      required this.validator,
      this.maxLines,
      this.minLines});

  @override
  State<TextFormFieldH> createState() => _TextFormFieldHState();
}

class _TextFormFieldHState extends State<TextFormFieldH> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var textStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16);
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 1.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 1.5)),
          errorStyle:
              TextStyle(color: Colors.red[500], fontWeight: FontWeight.w600)),
      cursorColor: theme.colorScheme.onPrimary,
      cursorErrorColor: theme.colorScheme.error,
      style: textStyle,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      // onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
