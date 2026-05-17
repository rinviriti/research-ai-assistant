class ResearchProfileModel {
  final String name;
  final String email;
  final String university;
  final String department;
  final String bio;
  final String location;
  final String lookingFor;
  final List<String> researchInterests;
  final List<String> skills;
  final List<String> publications;
  final List<String> projects;
  final String googleScholar;
  final String github;
  final String linkedIn;

  ResearchProfileModel({
    required this.name,
    required this.email,
    required this.university,
    required this.department,
    required this.bio,
    required this.location,
    required this.lookingFor,
    required this.researchInterests,
    required this.skills,
    required this.publications,
    required this.projects,
    required this.googleScholar,
    required this.github,
    required this.linkedIn,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "university": university,
      "department": department,
      "bio": bio,
      "location": location,
      "lookingFor": lookingFor,
      "researchInterests": researchInterests,
      "skills": skills,
      "publications": publications,
      "projects": projects,
      "googleScholar": googleScholar,
      "github": github,
      "linkedIn": linkedIn,
    };
  }

  factory ResearchProfileModel.fromJson(Map<String, dynamic> json) {
    return ResearchProfileModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      university: json["university"] ?? "",
      department: json["department"] ?? "",
      bio: json["bio"] ?? "",
      location: json["location"] ?? "",
      lookingFor: json["lookingFor"] ?? "",
      researchInterests: List<String>.from(json["researchInterests"] ?? []),
      skills: List<String>.from(json["skills"] ?? []),
      publications: List<String>.from(json["publications"] ?? []),
      projects: List<String>.from(json["projects"] ?? []),
      googleScholar: json["googleScholar"] ?? "",
      github: json["github"] ?? "",
      linkedIn: json["linkedIn"] ?? "",
    );
  }
}
