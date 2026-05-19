class MockDatabase {
  static final Map<String, List<Map<String, dynamic>>> collections = {
    "users": [],
    "posts": [],
    "comments": [],
    "connections": [],
    "matches": [],
    "messages": [],
    "chatThreads": [],
    "notifications": [],
    "shares": [],
  };

  static Future<void> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    collections[collection]?.add(data);
  }

  static Future<List<Map<String, dynamic>>> getCollection(
    String collection,
  ) async {
    return collections[collection] ?? [];
  }

  static Future<void> clearCollection(String collection) async {
    collections[collection]?.clear();
  }

  static Future<void> clearAll() async {
    for (final key in collections.keys) {
      collections[key]?.clear();
    }
  }
}
