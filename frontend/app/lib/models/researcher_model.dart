class ResearcherModel {
  final String name;
  final String university;
  final String department;
  final String bio;
  final List<String> interests;
  final List<String> skills;
  final String lookingFor;

  ResearcherModel({
    required this.name,
    required this.university,
    required this.department,
    required this.bio,
    required this.interests,
    required this.skills,
    required this.lookingFor,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "university": university,
      "department": department,
      "bio": bio,
      "interests": interests,
      "skills": skills,
      "lookingFor": lookingFor,
    };
  }

  factory ResearcherModel.fromJson(Map<String, dynamic> json) {
    return ResearcherModel(
      name: json["name"] ?? "",
      university: json["university"] ?? "",
      department: json["department"] ?? "",
      bio: json["bio"] ?? "",
      interests: List<String>.from(json["interests"] ?? []),
      skills: List<String>.from(json["skills"] ?? []),
      lookingFor: json["lookingFor"] ?? "",
    );
  }
}
