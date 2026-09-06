import '../../../memory/domain/entities/memory.dart';

class SearchResult {
  final String query;
  final List<Memory> matches;
  final Map<String, double> scores;

  const SearchResult({
    required this.query,
    required this.matches,
    this.scores = const {},
  });
}
