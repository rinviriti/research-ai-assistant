import 'package:flutter/material.dart';

import 'features/splash/screens/splash_screen.dart';
import 'services/notification_service.dart';
import 'services/connection_service.dart';
import 'services/research_messaging_service.dart';
import 'services/post_service.dart';
import 'services/comment_service.dart';
import 'services/saved_post_service.dart';
import 'services/share_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.loadNotifications();
  await ConnectionService.loadConnections();
  await ResearchMessagingService.loadMessages();
  await PostService.loadPosts();
  await CommentService.loadComments();
  await SavedPostService.loadSavedPosts();
  await ShareService.loadShares();

  runApp(const ResearchAIAssistantApp());
}

class ResearchAIAssistantApp extends StatelessWidget {
  const ResearchAIAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Research AI Assistant',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,

        scaffoldBackgroundColor: const Color(0xFF070B14),
        primaryColor: const Color(0xFF60A5FA),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF60A5FA),
          secondary: Color(0xFFA78BFA),
          surface: Color(0xFF111827),
          error: Color(0xFFF87171),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111827),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFFF8FAFC),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: IconThemeData(color: Color(0xFFF8FAFC)),
        ),

        cardColor: const Color(0xFF111827),
        dividerColor: Color(0xFF1F2937),

        iconTheme: const IconThemeData(color: Color(0xFF60A5FA)),

        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Color(0xFFF8FAFC),
            fontWeight: FontWeight.w800,
          ),
          headlineMedium: TextStyle(
            color: Color(0xFFF8FAFC),
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: TextStyle(color: Color(0xFFCBD5E1), height: 1.5),
          bodyMedium: TextStyle(color: Color(0xFFCBD5E1), height: 1.5),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF111827),
          hintStyle: const TextStyle(color: Color(0xFF64748B)),
          labelStyle: const TextStyle(color: Color(0xFFCBD5E1)),
          prefixIconColor: const Color(0xFF94A3B8),
          suffixIconColor: const Color(0xFF94A3B8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF1F2937)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 1.4),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF60A5FA),
            foregroundColor: const Color(0xFF020617),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          ),
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF111827),
          contentTextStyle: const TextStyle(color: Color(0xFFF8FAFC)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          behavior: SnackBarBehavior.floating,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF60A5FA),
          foregroundColor: Color(0xFF020617),
        ),

        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(const Color(0xFF60A5FA)),
          trackColor: MaterialStateProperty.all(
            const Color(0xFF60A5FA).withOpacity(0.35),
          ),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}
