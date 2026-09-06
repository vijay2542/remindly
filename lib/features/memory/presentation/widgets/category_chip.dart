import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  IconData _getCategoryIcon(Category category) {
    switch (category) {
      case Category.home:
        return Icons.home_outlined;
      case Category.family:
        return Icons.people_outline;
      case Category.work:
        return Icons.work_outline;
      case Category.vehicle:
        return Icons.directions_car_outlined;
      case Category.shopping:
        return Icons.shopping_bag_outlined;
      case Category.travel:
        return Icons.flight_takeoff_outlined;
      case Category.documents:
        return Icons.description_outlined;
      case Category.other:
        return Icons.folder_open_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = _getCategoryIcon(category);

    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onTap?.call(),
      avatar: Icon(icon, size: 18),
      label: Text(category.label),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
