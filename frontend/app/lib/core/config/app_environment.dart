class AppEnvironment {
  static const bool isDevelopment = true;

  // =========================================
  // AI PROVIDERS
  // =========================================

  static const String openAIApiKey = "";
  static const String geminiApiKey = "";

  // =========================================
  // BACKEND
  // =========================================

  static const String firebaseProjectId = "";
  static const String supabaseUrl = "";
  static const String supabaseAnonKey = "";

  // =========================================
  // APP CONFIG
  // =========================================

  static const int paginationLimit = 20;

  static const bool enableRealtimeMessaging = true;
  static const bool enableAiRecommendations = true;
  static const bool enableResearchFeed = true;

  // =========================================
  // FILE LIMITS
  // =========================================

  static const int maxPdfUploadMb = 25;
  static const int maxImageUploadMb = 10;

  // =========================================
  // AI MODELS
  // =========================================

  static const String summaryModel = "gpt-4.1-mini";
  static const String chatModel = "gpt-4.1-mini";
  static const String recommendationModel = "embedding-small";

  // =========================================
  // STORAGE KEYS
  // =========================================

  static const String onboardingKey = "has_seen_onboarding";
}
