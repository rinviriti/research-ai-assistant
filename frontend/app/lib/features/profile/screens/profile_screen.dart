import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();

  final bioController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = AuthService.currentUser ?? "Unknown User";
  }

  void saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully 🚀")),
    );

    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF1E293B),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.blueAccent,

              child: Icon(Icons.person, size: 55, color: Colors.white),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: nameController,

              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(
                labelText: "Full Name",

                labelStyle: const TextStyle(color: Colors.white70),

                filled: true,
                fillColor: Colors.white10,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: bioController,
              maxLines: 4,

              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(
                labelText: "Bio",

                labelStyle: const TextStyle(color: Colors.white70),

                filled: true,
                fillColor: Colors.white10,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: saveProfile,

                child: const Text(
                  "Save Profile",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 40),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),

                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Account Information",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Logged in as: ${AuthService.currentUser}",

                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Research AI Premium User",

                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
