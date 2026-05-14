import '../models/summary_model.dart';

class SummaryService {
  static final List<SummaryModel> savedSummaries = [];

  static void saveSummary(SummaryModel summary) {
    savedSummaries.add(summary);
  }

  static void deleteSummary(int index) {
    savedSummaries.removeAt(index);
  }

  static void clearAllSummaries() {
    savedSummaries.clear();
  }
}
