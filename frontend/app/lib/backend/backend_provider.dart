import 'repositories/auth_backend_repository.dart';
import 'repositories/comment_backend_repository.dart';
import 'repositories/connection_backend_repository.dart';
import 'repositories/matching_backend_repository.dart';
import 'repositories/messaging_backend_repository.dart';
import 'repositories/notification_backend_repository.dart';
import 'repositories/post_backend_repository.dart';
import 'repositories/profile_backend_repository.dart';
import 'repositories/saved_post_backend_repository.dart';
import 'repositories/share_backend_repository.dart';

class BackendProvider {
  static final auth = AuthBackendRepository();

  static final profile = ProfileBackendRepository();

  static final posts = PostBackendRepository();

  static final comments = CommentBackendRepository();

  static final messaging = MessagingBackendRepository();

  static final matching = MatchingBackendRepository();

  static final notifications = NotificationBackendRepository();

  static final connections = ConnectionBackendRepository();

  static final shares = ShareBackendRepository();

  static final savedPosts = SavedPostBackendRepository();
}
