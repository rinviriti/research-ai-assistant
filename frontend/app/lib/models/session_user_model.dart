class SessionUserModel {
  final String userId;
  final String name;
  final String email;

  SessionUserModel({
    required this.userId,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {"userId": userId, "name": name, "email": email};
  }

  factory SessionUserModel.fromJson(Map<String, dynamic> json) {
    return SessionUserModel(
      userId: json["userId"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
    );
  }
}
