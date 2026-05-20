import 'package:flutter/material.dart';

import '../../../services/notification_service.dart';

import '../home/screens/home_screen.dart';
import '../feed/screens/research_feed_screen.dart';
import '../matching/screens/swipe_matching_screen.dart';
import '../messaging/screens/research_messages_screen.dart';
import '../research_profile/screens/research_profile_screen.dart';
import '../notifications/screens/notifications_screen.dart';
import '../settings/screens/settings_screen.dart';
import '../search/screens/research_search_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    ResearchFeedScreen(),
    SwipeMatchingScreen(),
    ResearchMessagesScreen(),
    ResearchProfileScreen(),
  ];

  void openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResearchSearchScreen(autoFocus: true),
      ),
    );
  }

  Future<void> openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );

    if (!mounted) return;

    setState(() {});
  }

  void openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  Widget notificationIcon() {
    return StreamBuilder(
      stream: NotificationService.stream,
      initialData: NotificationService.getNotifications(),
      builder: (context, snapshot) {
        final unreadCount = NotificationService.unreadCount();

        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_none),
            if (unreadCount > 0)
              Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount > 9 ? "9+" : unreadCount.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget appHeader() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: const Border(bottom: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          children: [
            const Text(
              "RH+",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: openSearch,
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.white54, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Search research",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: "Notifications",
              onPressed: openNotifications,
              icon: notificationIcon(),
            ),
            IconButton(
              tooltip: "Settings",
              onPressed: openSettings,
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem navItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Icon(activeIcon),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          appHeader(),
          Expanded(
            child: IndexedStack(index: currentIndex, children: screens),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          navItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: "Home",
          ),
          navItem(
            icon: Icons.dynamic_feed_outlined,
            activeIcon: Icons.dynamic_feed,
            label: "Feed",
          ),
          navItem(
            icon: Icons.swipe_outlined,
            activeIcon: Icons.swipe,
            label: "Swipe",
          ),
          navItem(
            icon: Icons.forum_outlined,
            activeIcon: Icons.forum,
            label: "Messages",
          ),
          navItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
