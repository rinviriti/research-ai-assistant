import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class MediaService {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImageBase64() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (image == null) return null;

    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }
}
