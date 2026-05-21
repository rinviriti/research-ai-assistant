class ConnectionModel {
  final String researcherName;
  final String university;
  final String status;

  ConnectionModel({
    required this.researcherName,
    required this.university,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "researcherName": researcherName,
      "university": university,
      "status": status,
    };
  }

  factory ConnectionModel.fromJson(Map<String, dynamic> json) {
    return ConnectionModel(
      researcherName: json["researcherName"] ?? "",
      university: json["university"] ?? "",
      status: json["status"] ?? "pending",
    );
  }
}
