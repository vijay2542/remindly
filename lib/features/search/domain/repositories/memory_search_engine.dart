import '../entities/search_result.dart';

abstract class MemorySearchEngine {
  Future<SearchResult> search(String query, {int limit = 10});
}
