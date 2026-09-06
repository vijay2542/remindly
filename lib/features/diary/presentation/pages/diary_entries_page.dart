import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/diary_entry.dart';
import '../providers/diary_providers.dart';
import '../widgets/diary_entry_card.dart';

class DiaryEntriesPage extends ConsumerStatefulWidget {
  const DiaryEntriesPage({super.key});

  @override
  ConsumerState<DiaryEntriesPage> createState() => _DiaryEntriesPageState();
}

class _DiaryEntriesPageState extends ConsumerState<DiaryEntriesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DiaryEntry>? _searchResults;
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = null;
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    final searchUseCase = ref.read(searchDiaryEntriesUseCaseProvider);
    final results = await searchUseCase(query);
    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entriesAsync = ref.watch(diaryEntriesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Diary Entries'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search diary entries...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerLow,
              ),
            ),
          ),

          // Content List
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchResults != null
                    ? _buildEntriesList(context, ref, _searchResults!)
                    : entriesAsync.when(
                        data: (entries) => _buildEntriesList(context, ref, entries),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Center(child: Text('Error loading entries: $err')),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList(BuildContext context, WidgetRef ref, List<DiaryEntry> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_stories_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'No diary entries found.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.push('/diary/editor'),
              icon: const Icon(Icons.add),
              label: const Text('Write Diary Entry'),
              style: FilledButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return DiaryEntryCard(
          entry: entry,
          onTap: () => context.push('/diary/entry/${entry.id}'),
          onDelete: () => _confirmDelete(context, ref, entry.id),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Diary Entry?'),
        content: const Text('This entry will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final deleteUseCase = ref.read(deleteDiaryEntryUseCaseProvider);
              await deleteUseCase(id);
              if (_searchController.text.isNotEmpty) {
                _onSearchChanged(_searchController.text);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
