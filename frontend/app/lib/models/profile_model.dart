class ProfileModel {
  final String name;
  final String university;
  final String department;
  final String bio;
  final List<String> interests;
  final List<String> skills;
  final String email;
  final String github;
  final String linkedin;

  ProfileModel({
    required this.name,
    required this.university,
    required this.department,
    required this.bio,
    required this.interests,
    required this.skills,
    required this.email,
    required this.github,
    required this.linkedin,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "university": university,
      "department": department,
      "bio": bio,
      "interests": interests,
      "skills": skills,
      "email": email,
      "github": github,
      "linkedin": linkedin,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json["name"] ?? "",
      university: json["university"] ?? "",
      department: json["department"] ?? "",
      bio: json["bio"] ?? "",
      interests: List<String>.from(json["interests"] ?? []),
      skills: List<String>.from(json["skills"] ?? []),
      email: json["email"] ?? "",
      github: json["github"] ?? "",
      linkedin: json["linkedin"] ?? "",
    );
  }
}
