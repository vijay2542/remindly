import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/diary_entry.dart';
import '../providers/diary_providers.dart';
import '../widgets/diary_entry_card.dart';

class DiaryCalendarPage extends ConsumerStatefulWidget {
  const DiaryCalendarPage({super.key});

  @override
  ConsumerState<DiaryCalendarPage> createState() => _DiaryCalendarPageState();
}

class _DiaryCalendarPageState extends ConsumerState<DiaryCalendarPage> {
  late DateTime _currentMonth;
  DateTime _selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entriesAsync = ref.watch(diaryEntriesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Calendar'),
      ),
      body: entriesAsync.when(
        data: (entries) {
          // Map entries by date String 'yyyy-MM-dd'
          final entryDates = <String, DiaryEntry>{};
          for (final entry in entries) {
            final key = '${entry.diaryDate.year}-${entry.diaryDate.month.toString().padLeft(2, '0')}-${entry.diaryDate.day.toString().padLeft(2, '0')}';
            entryDates[key] = entry;
          }

          final selectedKey = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
          final selectedEntry = entryDates[selectedKey];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Header Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _previousMonth,
                    ),
                    Text(
                      DateFormatter.formatDate(_currentMonth).split(',').first, // e.g. September 2026
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _nextMonth,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Days of Week Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].map((day) {
                    return SizedBox(
                      width: 40,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),

                // Calendar Days Grid
                _buildCalendarGrid(context, entryDates),
                const SizedBox(height: 24),

                // Selected Date Summary
                Text(
                  DateFormatter.formatDate(_selectedDate),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                if (selectedEntry != null) ...[
                  DiaryEntryCard(
                    entry: selectedEntry,
                    onTap: () => context.push('/diary/entry/${selectedEntry.id}'),
                  ),
                ] else ...[
                  Card(
                    elevation: 0,
                    color: theme.colorScheme.surfaceContainerLow,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text('No entry for this date.'),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () => context.push('/diary/editor'),
                            icon: const Icon(Icons.add),
                            label: const Text('Write Diary Entry'),
                            style: FilledButton.styleFrom(backgroundColor: Colors.teal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading calendar: $err')),
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, Map<String, DiaryEntry> entryDates) {
    final theme = Theme.of(context);
    final daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstDayOfWeek = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;

    final totalGridCells = firstDayOfWeek + daysInMonth;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalGridCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        if (index < firstDayOfWeek) {
          return const SizedBox.shrink();
        }

        final dayNumber = index - firstDayOfWeek + 1;
        final dateCell = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
        final dateKey = '${dateCell.year}-${dateCell.month.toString().padLeft(2, '0')}-${dateCell.day.toString().padLeft(2, '0')}';
        final hasEntry = entryDates.containsKey(dateKey);

        final isSelected = _selectedDate.year == dateCell.year &&
            _selectedDate.month == dateCell.month &&
            _selectedDate.day == dateCell.day;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = dateCell;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isSelected ? Colors.teal : (hasEntry ? Colors.teal.withValues(alpha: 0.15) : null),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.teal : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontWeight: isSelected || hasEntry ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                  ),
                ),
                if (hasEntry && !isSelected)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
