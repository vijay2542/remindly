import 'package:flutter/material.dart';

class TagInput extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<String> onTagAdded;
  final ValueChanged<String> onTagRemoved;

  const TagInput({
    super.key,
    required this.tags,
    required this.onTagAdded,
    required this.onTagRemoved,
  });

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  final TextEditingController _controller = TextEditingController();

  void _submitTag() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onTagAdded(text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Add Tag (e.g. #keys, #security)',
                  prefixIcon: const Icon(Icons.tag),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
                onSubmitted: (_) => _submitTag(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: _submitTag,
              icon: const Icon(Icons.add),
              tooltip: 'Add Tag',
            ),
          ],
        ),
        if (widget.tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: widget.tags.map((tag) {
              return Chip(
                label: Text('#$tag'),
                onDeleted: () => widget.onTagRemoved(tag),
                deleteIcon: const Icon(Icons.close, size: 16),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
