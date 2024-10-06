import 'dart:convert';
import 'dart:typed_data';

class AppUtils {
  Uint8List getImageByBase64(String image64) {
    return base64Decode(image64.split(',').last);
  }
}
