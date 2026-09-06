import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../about/presentation/pages/about_page.dart';
import '../../../memory/presentation/widgets/memory_card.dart';
import '../../../voice/presentation/widgets/speech_dialog.dart';
import '../providers/search_providers.dart';
import '../widgets/answer_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  final String? initialQuery;
  final bool startVoice;

  const SearchPage({
    super.key,
    this.initialQuery,
    this.startVoice = false,
  });

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchNotifierProvider.notifier).executeQuery(widget.initialQuery!);
      });
    }

    if (widget.startVoice) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerVoiceSearch();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    ref.read(searchNotifierProvider.notifier).executeQuery(query);
  }

  Future<void> _triggerVoiceSearch() async {
    final recognizedText = await SpeechDialog.show(context);
    if (recognizedText != null && recognizedText.isNotEmpty && mounted) {
      setState(() {
        _searchController.text = recognizedText;
      });
      _onSearchSubmitted(recognizedText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchState = ref.watch(searchNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: widget.initialQuery == null || widget.initialQuery!.isEmpty,
          textInputAction: TextInputAction.search,
          onSubmitted: _onSearchSubmitted,
          decoration: InputDecoration(
            hintText: 'Ask or search memories...',
            border: InputBorder.none,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchNotifierProvider.notifier).executeQuery('');
                    },
                  ),
                IconButton(
                  icon: Icon(Icons.mic, color: theme.colorScheme.primary),
                  tooltip: 'Voice Command Search',
                  onPressed: _triggerVoiceSearch,
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              searchState.isVoiceReadoutEnabled ? Icons.volume_up : Icons.volume_off_outlined,
              color: searchState.isVoiceReadoutEnabled ? theme.colorScheme.primary : theme.colorScheme.outline,
            ),
            tooltip: searchState.isVoiceReadoutEnabled ? 'Voice readout enabled' : 'Voice readout disabled',
            onPressed: () => ref.read(searchNotifierProvider.notifier).toggleVoiceReadout(),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => _onSearchSubmitted(_searchController.text),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About Software',
            onPressed: () => showAppAboutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (searchState.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (searchState.error != null)
              Center(child: Text(searchState.error!))
            else if (searchState.query.isNotEmpty) ...[
              if (searchState.answer != null) ...[
                AnswerCard(answer: searchState.answer!),
                const SizedBox(height: 24),
              ],
              if (searchState.matches.isNotEmpty) ...[
                Text(
                  'Matching Memories (${searchState.matches.length})',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchState.matches.length,
                  itemBuilder: (context, index) {
                    final memory = searchState.matches[index];
                    return MemoryCard(
                      memory: memory,
                      onTap: () => context.push('/memory/${memory.id}'),
                    );
                  },
                ),
              ],
            ] else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(Icons.search_outlined, size: 64, color: theme.colorScheme.outlineVariant),
                      const SizedBox(height: 16),
                      Text(
                        'Speak or type a question to search your memories',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _triggerVoiceSearch,
                        icon: const Icon(Icons.mic),
                        label: const Text('Voice Command Search'),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        children: [
                          ActionChip(
                            label: const Text('"Where is the spare key?"'),
                            onPressed: () {
                              _searchController.text = 'Where is the spare key?';
                              _onSearchSubmitted(_searchController.text);
                            },
                          ),
                          ActionChip(
                            label: const Text('"washing machine"'),
                            onPressed: () {
                              _searchController.text = 'washing machine';
                              _onSearchSubmitted(_searchController.text);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
