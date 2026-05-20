import 'package:flutter/material.dart';

import '../../../services/connection_service.dart';
import '../../../services/research_messaging_service.dart';
import '../../messaging/screens/research_chat_detail_screen.dart';

class ResearcherProfilePreviewScreen extends StatefulWidget {
  final String name;
  final String university;
  final List<String> interests;

  const ResearcherProfilePreviewScreen({
    super.key,
    required this.name,
    required this.university,
    this.interests = const [],
  });

  @override
  State<ResearcherProfilePreviewScreen> createState() =>
      _ResearcherProfilePreviewScreenState();
}

class _ResearcherProfilePreviewScreenState
    extends State<ResearcherProfilePreviewScreen> {
  bool get isConnected => ConnectionService.isConnected(widget.name);

  List<String> get profileInterests {
    if (widget.interests.isEmpty) {
      return ["Research", "Collaboration"];
    }

    return widget.interests;
  }

  void openMessage() {
    ResearchMessagingService.createThread(
      researcherName: widget.name,
      university: widget.university,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResearchChatDetailScreen(
          researcherName: widget.name,
          university: widget.university,
        ),
      ),
    );
  }

  void connectResearcher() {
    if (isConnected) return;

    ConnectionService.sendRequest(
      researcherName: widget.name,
      university: widget.university,
    );

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Connection request sent to ${widget.name}.")),
    );
  }

  Widget profileHeader() {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Container(
            height: 110,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              gradient: LinearGradient(
                colors: [
                  primary.withOpacity(0.45),
                  primary.withOpacity(0.12),
                  Theme.of(context).cardColor,
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -48),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 58,
                  backgroundColor: primary,
                  child: Text(
                    widget.name.substring(0, 1),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Icon(Icons.verified, color: primary, size: 20),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  widget.university,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),

                const SizedBox(height: 18),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      statItem(profileInterests.length.toString(), "Interests"),
                      Container(width: 1, height: 38, color: Colors.white12),
                      statItem(isConnected ? "1" : "0", "Connection"),
                      Container(width: 1, height: 38, color: Colors.white12),
                      statItem("RH+", "Network"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isConnected ? null : connectResearcher,
                          icon: Icon(
                            isConnected
                                ? Icons.check_circle_outline
                                : Icons.person_add_alt_1,
                          ),
                          label: Text(isConnected ? "Request Sent" : "Connect"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: openMessage,
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text("Message"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget statItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title, IconData icon) {
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 22),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget chipList() {
    final primary = Theme.of(context).colorScheme.primary;

    return Wrap(
      children: profileInterests.map((interest) {
        return Container(
          margin: const EdgeInsets.only(right: 10, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.14),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: primary.withOpacity(0.30)),
          ),
          child: Text(
            interest,
            style: TextStyle(color: primary, fontWeight: FontWeight.w600),
          ),
        );
      }).toList(),
    );
  }

  Widget aboutCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: const Text(
        "This RH+ profile preview helps you inspect a researcher, review their research interests, connect with them, and start a professional academic conversation.",
        style: TextStyle(color: Colors.white70, height: 1.5),
      ),
    );
  }

  Widget compatibilityCard() {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.psychology_outlined, color: primary, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Potential research collaboration based on shared academic interests.",
              style: TextStyle(
                color: primary,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Researcher Profile")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          profileHeader(),

          sectionTitle("Research Interests", Icons.psychology_outlined),

          chipList(),

          sectionTitle("Collaboration Insight", Icons.auto_awesome),

          compatibilityCard(),

          const SizedBox(height: 24),

          aboutCard(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
