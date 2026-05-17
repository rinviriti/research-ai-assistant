import 'package:flutter/material.dart';

import '../../../models/connection_model.dart';
import '../../../services/connection_service.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  Widget connectionCard(ConnectionModel connection) {
    final primary = Theme.of(context).colorScheme.primary;
    final isPending = connection.status == "pending";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  connection.university,
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

          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Chat with ${connection.researcherName} coming soon.",
                  ),
                ),
              );
            },
            icon: Icon(Icons.chat_bubble_outline, color: primary),
          ),
        ],
      ),
    );
  }

  Widget emptyState() {
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
              "Connect with researchers from the Research Feed or Find Researchers page. Your pending requests and accepted collaborators will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget statsHeader() {
    final connections = ConnectionService.connections;
    final pendingCount = connections
        .where((connection) => connection.status == "pending")
        .length;
    final acceptedCount = connections
        .where((connection) => connection.status == "accepted")
        .length;

    final primary = Theme.of(context).colorScheme.primary;

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
          Expanded(
            child: Column(
              children: [
                Text(
                  connections.length.toString(),
                  style: TextStyle(
                    color: primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Total", style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),
          Container(width: 1, height: 45, color: Colors.white12),
          Expanded(
            child: Column(
              children: [
                Text(
                  pendingCount.toString(),
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Pending", style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),
          Container(width: 1, height: 45, color: Colors.white12),
          Expanded(
            child: Column(
              children: [
                Text(
                  acceptedCount.toString(),
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Connected",
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connections = ConnectionService.connections;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Research Connections")),
      body: connections.isEmpty
          ? emptyState()
          : ListView(
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
                  "Manage collaboration requests, research connections, and future academic networking contacts.",
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),

                const SizedBox(height: 24),

                statsHeader(),

                ...connections.map(connectionCard),
              ],
            ),
    );
  }
}
