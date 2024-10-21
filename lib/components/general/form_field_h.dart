import 'package:flutter/material.dart';

class FormFieldH extends StatelessWidget {
  final String label;
  final Widget child;
  const FormFieldH({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final textLabelStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: textLabelStyle,
        ),
        SizedBox(
          height: 16,
        ),
        child
      ],
    );
  }
}
