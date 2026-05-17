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

  static int calculateMatchScore(
    List<String> myInterests,
    List<String> otherInterests,
  ) {
    final mySet = myInterests.map((e) => e.toLowerCase()).toSet();
    final otherSet = otherInterests.map((e) => e.toLowerCase()).toSet();

    final shared = mySet.intersection(otherSet).length;
    final total = mySet.union(otherSet).length;

    if (total == 0) return 0;

    return ((shared / total) * 100).round();
  }
}
