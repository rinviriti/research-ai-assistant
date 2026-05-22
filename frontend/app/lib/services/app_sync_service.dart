import 'auth_service.dart';
import 'comment_service.dart';
import 'connection_service.dart';
import 'experiment_service.dart';
import 'notification_service.dart';
import 'note_service.dart';
import 'post_service.dart';
import 'research_messaging_service.dart';
import 'research_profile_service.dart';
import 'saved_post_service.dart';
import 'share_service.dart';
import 'summary_service.dart';

class AppSyncService {
  static Future<void> initializeApp() async {
    await AuthService.isLoggedIn();

    await NotificationService.loadNotifications();
    await ConnectionService.loadConnections();
    await ResearchMessagingService.loadMessages();
    await PostService.loadPosts();
    await CommentService.loadComments();
    await SavedPostService.loadSavedPosts();
    await ShareService.loadShares();
    await SummaryService.loadSummaries();
    await ExperimentService.loadExperiments();
    await NoteService.loadNotes();
    await ResearchProfileService.loadProfile();
  }

  static Future<void> clearAllLocalData() async {
    await ResearchProfileService.deleteProfile();
  }

  static Future<void> refreshEverything() async {
    await initializeApp();
  }
}
