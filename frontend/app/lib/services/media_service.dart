import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../models/post_media_model.dart';

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

  static Future<PostMediaModel?> pickPostImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (image == null) return null;

    final bytes = await image.readAsBytes();

    return PostMediaModel(
      mediaId: DateTime.now().microsecondsSinceEpoch.toString(),
      type: PostMediaType.image,
      fileName: image.name,
      base64Data: base64Encode(bytes),
    );
  }

  static Future<PostMediaModel?> pickPostPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;

    if (file.bytes == null) return null;

    return PostMediaModel(
      mediaId: DateTime.now().microsecondsSinceEpoch.toString(),
      type: PostMediaType.pdf,
      fileName: file.name,
      base64Data: base64Encode(file.bytes!),
    );
  }

  static Future<String?> pickPdfBase64() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;

    if (file.bytes == null) return null;

    return base64Encode(file.bytes!);
  }
}
