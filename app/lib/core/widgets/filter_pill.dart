import 'package:flutter/material.dart';

/// A tappable filter pill used in the Home filters bar.
///
/// Shows just [label] when nothing is selected, or `"label: value"` highlighted
/// when [value] is set. A check icon hints that re-opening it can clear the
/// selection.
class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
  });

  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = value != null;
    return ActionChip(
      avatar: Icon(selected ? Icons.check : Icons.expand_more, size: 18),
      label: Text(selected ? '$label: $value' : label),
      onPressed: onTap,
      backgroundColor: selected
          ? Theme.of(context).colorScheme.secondaryContainer
          : null,
    );
  }
}
