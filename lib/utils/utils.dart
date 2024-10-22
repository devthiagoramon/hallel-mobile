import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppUtils {
  Uint8List getImageByBase64(String image64) {
    return base64Decode(image64.split(',').last);
  }

  static Future<dynamic> modalDelete(
      BuildContext context, String title, Future<void> Function() onTap) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.chevron_left, size: 24),
                SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              ],
            ),
            content: Text(
              "Essa ação não pode ser desfeita",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await onTap();
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Excluir",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  )),
            ],
          );
        });
  }
}
