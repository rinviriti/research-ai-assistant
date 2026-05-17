import '../models/post_model.dart';

class PostService {
  static final List<PostModel> posts = [
    PostModel(
      author: "Rinvi Jaman Riti",
      university: "Daffodil International University",
      content:
          "Testing Swin-UNet++ on MRI segmentation dataset. Current Dice score reached 0.91. Looking for suggestions to improve ET segmentation performance.",
      type: "Ongoing Research",
      tags: ["Medical Imaging", "Segmentation", "Deep Learning"],
      timeAgo: "2h ago",
      likes: 12,
    ),

    PostModel(
      author: "Dr. Aiko Tanaka",
      university: "University of Tokyo",
      content:
          "Published new paper on AI-assisted clinical diagnosis using multimodal MRI analysis.",
      type: "Publication",
      tags: ["Clinical AI", "MRI", "Healthcare"],
      timeAgo: "5h ago",
      likes: 31,
    ),

    PostModel(
      author: "Md. Rahat Hossain",
      university: "BUET",
      content:
          "Can anyone suggest good datasets for real-time bronchoscopy lesion detection research?",
      type: "Research Question",
      tags: ["Bronchoscopy", "YOLO", "Computer Vision"],
      timeAgo: "8h ago",
      likes: 7,
    ),
  ];
}
