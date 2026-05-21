class ResearchProfileModel {
  final String userId;

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
  final String orcid;
  final String website;

  final String profileImagePath;
  final String cvPath;

  final bool isVerified;

  final DateTime createdAt;
  final DateTime updatedAt;

  ResearchProfileModel({
    required this.userId,
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
    required this.orcid,
    required this.website,
    required this.profileImagePath,
    required this.cvPath,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  double get completionPercentage {
    int score = 0;

    if (name.isNotEmpty) score++;
    if (email.isNotEmpty) score++;
    if (university.isNotEmpty) score++;
    if (department.isNotEmpty) score++;
    if (bio.isNotEmpty) score++;
    if (location.isNotEmpty) score++;
    if (lookingFor.isNotEmpty) score++;
    if (researchInterests.isNotEmpty) score++;
    if (skills.isNotEmpty) score++;
    if (publications.isNotEmpty) score++;
    if (projects.isNotEmpty) score++;
    if (googleScholar.isNotEmpty) score++;
    if (github.isNotEmpty) score++;
    if (linkedIn.isNotEmpty) score++;
    if (orcid.isNotEmpty) score++;
    if (website.isNotEmpty) score++;
    if (profileImagePath.isNotEmpty) score++;
    if (cvPath.isNotEmpty) score++;

    return (score / 18) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
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
      "orcid": orcid,
      "website": website,
      "profileImagePath": profileImagePath,
      "cvPath": cvPath,
      "isVerified": isVerified,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  factory ResearchProfileModel.fromJson(Map<String, dynamic> json) {
    return ResearchProfileModel(
      userId: json["userId"] ?? "",
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
      orcid: json["orcid"] ?? "",
      website: json["website"] ?? "",
      profileImagePath: json["profileImagePath"] ?? "",
      cvPath: json["cvPath"] ?? "",
      isVerified: json["isVerified"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
    );
  }

  ResearchProfileModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? university,
    String? department,
    String? bio,
    String? location,
    String? lookingFor,
    List<String>? researchInterests,
    List<String>? skills,
    List<String>? publications,
    List<String>? projects,
    String? googleScholar,
    String? github,
    String? linkedIn,
    String? orcid,
    String? website,
    String? profileImagePath,
    String? cvPath,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ResearchProfileModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      university: university ?? this.university,
      department: department ?? this.department,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      lookingFor: lookingFor ?? this.lookingFor,
      researchInterests: researchInterests ?? this.researchInterests,
      skills: skills ?? this.skills,
      publications: publications ?? this.publications,
      projects: projects ?? this.projects,
      googleScholar: googleScholar ?? this.googleScholar,
      github: github ?? this.github,
      linkedIn: linkedIn ?? this.linkedIn,
      orcid: orcid ?? this.orcid,
      website: website ?? this.website,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      cvPath: cvPath ?? this.cvPath,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
