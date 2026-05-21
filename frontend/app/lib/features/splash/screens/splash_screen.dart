import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/auth_service.dart';
import '../../../services/summary_service.dart';
import '../../../services/experiment_service.dart';
import '../../../services/note_service.dart';
import '../../../services/chat_service.dart';

import '../../auth/screens/login_screen.dart';
import '../../navigation/main_navigation_screen.dart';
import '../../onboarding/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadAppData();
  }

  Future<void> loadAppData() async {
    await SummaryService.loadSummaries();
    await ExperimentService.loadExperiments();
    await NoteService.loadNotes();
    await ChatService.loadChat();

    final prefs = await SharedPreferences.getInstance();

    final hasSeenOnboarding = prefs.getBool("rh_has_seen_onboarding") ?? false;

    final loggedIn = await AuthService.isLoggedIn();

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      await prefs.setBool("rh_has_seen_onboarding", true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );

      return;
    }

    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              color: Theme.of(context).colorScheme.primary,
              size: 58,
            ),
            const SizedBox(height: 18),
            const Text(
              "RH+",
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
