import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImageAndConvertToBase64() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return null;
      }

      final bytes = await File(image.path).readAsBytes();

      String base64Image = base64Encode(bytes);
      return base64Image;
    } catch (e) {
      log("Error getting image", name: "ImagePickerUtil");
      return null;
    }
  }
}
