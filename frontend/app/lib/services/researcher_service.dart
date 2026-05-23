import '../models/collaborator_recommendation_model.dart';
import '../models/research_profile_model.dart';
import '../models/researcher_model.dart';

class ResearcherService {
  static final List<ResearcherModel> researchers = [
    ResearcherModel(
      name: "Rinvi Jaman Riti",
      university: "Daffodil International University",
      department: "Computer Science and Engineering",
      bio:
          "Interested in AI, medical imaging, research productivity, and academic collaboration.",
      interests: [
        "Medical Imaging",
        "Deep Learning",
        "Brain Tumor Segmentation",
        "Flutter",
      ],
      skills: [
        "Flutter",
        "Machine Learning",
        "Research Writing",
        "Data Analysis",
      ],
      lookingFor: "Research collaborators and supervisors",
    ),
    ResearcherModel(
      name: "Dr. Aiko Tanaka",
      university: "University of Tokyo",
      department: "Biomedical Engineering",
      bio:
          "Researching AI-assisted medical diagnosis and clinical decision support systems.",
      interests: [
        "Medical Imaging",
        "AI Healthcare",
        "Segmentation",
        "Clinical AI",
      ],
      skills: ["Deep Learning", "MRI Analysis", "Medical Research"],
      lookingFor: "Graduate students and research collaborators",
    ),
    ResearcherModel(
      name: "Md. Rahat Hossain",
      university: "BUET",
      department: "Computer Science and Engineering",
      bio:
          "Working on computer vision, object detection, and real-time AI systems.",
      interests: ["Computer Vision", "YOLO", "Object Detection", "Medical AI"],
      skills: ["Python", "PyTorch", "YOLO", "Research Experiments"],
      lookingFor: "AI project partners",
    ),
  ];

  static Set<String> normalizeList(List<String> items) {
    return items
        .map((item) => item.trim().toLowerCase())
        .where((item) => item.isNotEmpty)
        .toSet();
  }

  static List<String> sharedItems(List<String> mine, List<String> other) {
    final mySet = normalizeList(mine);
    final otherSet = normalizeList(other);

    final shared = mySet.intersection(otherSet);

    return mine
        .where((item) => shared.contains(item.trim().toLowerCase()))
        .toList();
  }

  static int calculateMatchScore(
    List<String> myInterests,
    List<String> otherInterests, {
    List<String> mySkills = const [],
    List<String> otherSkills = const [],
  }) {
    final myInterestSet = normalizeList(myInterests);
    final otherInterestSet = normalizeList(otherInterests);

    final mySkillSet = normalizeList(mySkills);
    final otherSkillSet = normalizeList(otherSkills);

    final sharedInterests = myInterestSet.intersection(otherInterestSet).length;
    final sharedSkills = mySkillSet.intersection(otherSkillSet).length;

    final interestScore = otherInterestSet.isEmpty
        ? 0
        : ((sharedInterests / otherInterestSet.length) * 70).round();

    final skillScore = otherSkillSet.isEmpty
        ? 0
        : ((sharedSkills / otherSkillSet.length) * 30).round();

    return interestScore + skillScore;
  }

  static String buildReason({
    required ResearcherModel researcher,
    required List<String> sharedInterests,
    required List<String> sharedSkills,
  }) {
    if (sharedInterests.isNotEmpty && sharedSkills.isNotEmpty) {
      return "Strong overlap in ${sharedInterests.take(2).join(", ")} with shared skills in ${sharedSkills.take(2).join(", ")}.";
    }

    if (sharedInterests.isNotEmpty) {
      return "Research interests overlap in ${sharedInterests.take(3).join(", ")}.";
    }

    if (sharedSkills.isNotEmpty) {
      return "Technical skill overlap in ${sharedSkills.take(3).join(", ")}.";
    }

    return "${researcher.name} may still be useful for broad academic networking.";
  }

  static String recommendedAction(int score) {
    if (score >= 70) {
      return "High-priority collaborator. Send a connection request.";
    }

    if (score >= 45) {
      return "Good potential match. Review profile and message if relevant.";
    }

    if (score >= 20) {
      return "Moderate match. Save for later exploration.";
    }

    return "Low overlap. Consider only for general networking.";
  }

  static List<CollaboratorRecommendationModel> recommendCollaborators(
    ResearchProfileModel profile,
  ) {
    final recommendations = researchers.map((researcher) {
      final sharedInterests = sharedItems(
        profile.researchInterests,
        researcher.interests,
      );

      final sharedSkills = sharedItems(profile.skills, researcher.skills);

      final score = calculateMatchScore(
        profile.researchInterests,
        researcher.interests,
        mySkills: profile.skills,
        otherSkills: researcher.skills,
      );

      return CollaboratorRecommendationModel(
        researcher: researcher,
        score: score,
        sharedInterests: sharedInterests,
        sharedSkills: sharedSkills,
        reason: buildReason(
          researcher: researcher,
          sharedInterests: sharedInterests,
          sharedSkills: sharedSkills,
        ),
        recommendedAction: recommendedAction(score),
      );
    }).toList();

    recommendations.sort((a, b) => b.score.compareTo(a.score));

    return recommendations;
  }
}
