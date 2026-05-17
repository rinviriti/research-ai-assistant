import 'package:flutter/material.dart';

import '../../../models/researcher_model.dart';
import '../../../services/researcher_service.dart';

class ResearcherScreen extends StatelessWidget {
  const ResearcherScreen({super.key});

  final List<String> myInterests = const [
    "Medical Imaging",
    "Deep Learning",
    "Brain Tumor Segmentation",
    "Flutter",
  ];

  Widget tagChip(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget researcherCard(BuildContext context, ResearcherModel researcher) {
    final primary = Theme.of(context).colorScheme.primary;

    final matchScore = ResearcherService.calculateMatchScore(
      myInterests,
      researcher.interests,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: primary,
                child: Text(
                  researcher.name.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      researcher.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      researcher.university,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      researcher.department,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: primary.withOpacity(0.4)),
                ),
                child: Text(
                  "$matchScore% Match",
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            researcher.bio,
            style: const TextStyle(color: Colors.white70, height: 1.5),
          ),

          const SizedBox(height: 18),

          const Text(
            "Research Interests",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Wrap(
            children: researcher.interests
                .map((interest) => tagChip(context, interest))
                .toList(),
          ),

          const SizedBox(height: 14),

          const Text(
            "Skills",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Wrap(
            children: researcher.skills
                .map((skill) => tagChip(context, skill))
                .toList(),
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    researcher.lookingFor,
                    style: const TextStyle(color: Colors.white70, height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Researcher request sent to ${researcher.name}",
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text("Add Researcher"),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 50,
                width: 52,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Opening chat with ${researcher.name}"),
                      ),
                    );
                  },
                  child: const Icon(Icons.chat),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget myProfileCard(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.25), Theme.of(context).cardColor],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Research Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "These interests are used to calculate your research compatibility score with other researchers.",
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 14),
          Wrap(
            children: myInterests
                .map((interest) => tagChip(context, interest))
                .toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final researchers = ResearcherService.researchers;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Find Researchers")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Researcher Match",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Find researchers, professors, and collaborators with similar academic interests.",
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),

          const SizedBox(height: 24),

          myProfileCard(context),

          ...researchers.map(
            (researcher) => researcherCard(context, researcher),
          ),
        ],
      ),
    );
  }
}
