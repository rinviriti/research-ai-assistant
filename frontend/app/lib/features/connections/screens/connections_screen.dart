import 'package:flutter/material.dart';

import '../../../models/connection_model.dart';
import '../../../services/connection_service.dart';
import '../../../services/research_messaging_service.dart';
import '../../messaging/screens/research_chat_detail_screen.dart';
import '../../researchers/screens/researcher_profile_preview_screen.dart';

class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({super.key});

  void openChat(BuildContext context, ConnectionModel connection) {
    ResearchMessagingService.createThread(
      researcherName: connection.researcherName,
      university: connection.university,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResearchChatDetailScreen(
          researcherName: connection.researcherName,
          university: connection.university,
        ),
      ),
    );
  }

  void openProfile(BuildContext context, ConnectionModel connection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResearcherProfilePreviewScreen(
          name: connection.researcherName,
          university: connection.university,
          interests: const ["Research", "Collaboration"],
        ),
      ),
    );
  }

  Widget statItem({
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget statsHeader(BuildContext context, List<ConnectionModel> connections) {
    final primary = Theme.of(context).colorScheme.primary;

    final pendingCount = connections
        .where((connection) => connection.status == "pending")
        .length;

    final acceptedCount = connections
        .where((connection) => connection.status == "accepted")
        .length;

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.18), Theme.of(context).cardColor],
        ),
      ),
      child: Row(
        children: [
          statItem(
            value: connections.length.toString(),
            label: "Total",
            color: primary,
          ),
          Container(width: 1, height: 45, color: Colors.white12),
          statItem(
            value: pendingCount.toString(),
            label: "Pending",
            color: Colors.orangeAccent,
          ),
          Container(width: 1, height: 45, color: Colors.white12),
          statItem(
            value: acceptedCount.toString(),
            label: "Connected",
            color: Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  Widget connectionCard(BuildContext context, ConnectionModel connection) {
    final primary = Theme.of(context).colorScheme.primary;
    final isPending = connection.status == "pending";
    final isAccepted = connection.status == "accepted";

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => openProfile(context, connection),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isAccepted
                ? Colors.greenAccent.withOpacity(0.35)
                : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: isPending ? Colors.orangeAccent : primary,
              child: Text(
                connection.researcherName.substring(0, 1),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 23,
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
                    connection.researcherName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    connection.university,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isPending
                          ? Colors.orangeAccent.withOpacity(0.14)
                          : Colors.greenAccent.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isPending
                            ? Colors.orangeAccent.withOpacity(0.45)
                            : Colors.greenAccent.withOpacity(0.45),
                      ),
                    ),
                    child: Text(
                      isPending ? "Pending Request" : "Connected",
                      style: TextStyle(
                        color: isPending
                            ? Colors.orangeAccent
                            : Colors.greenAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                if (isPending)
                  IconButton(
                    tooltip: "Accept",
                    onPressed: () {
                      ConnectionService.acceptConnection(
                        connection.researcherName,
                      );
                    },
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.greenAccent,
                    ),
                  ),

                IconButton(
                  tooltip: "Message",
                  onPressed: () => openChat(context, connection),
                  icon: Icon(Icons.chat_bubble_outline, color: primary),
                ),

                IconButton(
                  tooltip: "Remove",
                  onPressed: () {
                    ConnectionService.removeConnection(
                      connection.researcherName,
                    );
                  },
                  icon: const Icon(Icons.close, color: Colors.white38),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyState(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_alt_outlined, color: primary, size: 84),

            const SizedBox(height: 20),

            const Text(
              "No connections yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Connect with researchers from the Research Feed, Search page, or Swipe Match. Your pending requests and accepted collaborators will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget content(BuildContext context, List<ConnectionModel> connections) {
    if (connections.isEmpty) {
      return emptyState(context);
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Your Research Network",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Manage collaboration requests, research connections, and academic networking contacts.",
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),

        const SizedBox(height: 24),

        statsHeader(context, connections),

        ...connections.map((connection) => connectionCard(context, connection)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Research Connections")),
      body: StreamBuilder<List<ConnectionModel>>(
        stream: ConnectionService.stream,
        initialData: ConnectionService.getConnections(),
        builder: (context, snapshot) {
          final connections = snapshot.data ?? [];

          return content(context, connections);
        },
      ),
    );
  }
}
