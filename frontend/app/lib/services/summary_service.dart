import '../models/summary_model.dart';

class SummaryService {
  static final List<SummaryModel> savedSummaries = [];

  static void saveSummary(SummaryModel summary) {
    savedSummaries.add(summary);
  }
}
