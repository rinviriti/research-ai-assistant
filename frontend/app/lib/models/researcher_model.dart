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
}
