enum PostMediaType { image, pdf }

class PostMediaModel {
  final String mediaId;
  final PostMediaType type;
  final String fileName;
  final String base64Data;

  PostMediaModel({
    required this.mediaId,
    required this.type,
    required this.fileName,
    required this.base64Data,
  });

  Map<String, dynamic> toJson() {
    return {
      "mediaId": mediaId,
      "type": type.name,
      "fileName": fileName,
      "base64Data": base64Data,
    };
  }

  factory PostMediaModel.fromJson(Map<String, dynamic> json) {
    return PostMediaModel(
      mediaId: json["mediaId"] ?? "",
      type: json["type"] == "pdf" ? PostMediaType.pdf : PostMediaType.image,
      fileName: json["fileName"] ?? "",
      base64Data: json["base64Data"] ?? "",
    );
  }
}
