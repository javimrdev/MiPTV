import 'package:flutter/material.dart';
import 'package:miptv/core/platform/app_platform.dart';
import 'package:miptv/core/widgets/glass/crystal_glass.dart';
import 'package:miptv/l10n/app_localizations.dart';

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

    if (!isIOSGlass) {
      return ActionChip(
        avatar: Icon(selected ? Icons.check : Icons.expand_more, size: 18),
        label: Text(
          selected
              ? AppLocalizations.of(context).filterPill(label, value!)
              : label,
        ),
        onPressed: onTap,
        backgroundColor: selected
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
      );
    }

    final scheme = Theme.of(context).colorScheme;
    return CrystalGlass(
      borderRadius: BorderRadius.circular(22),
      selected: selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.check : Icons.expand_more,
                size: 18,
                color: selected ? scheme.primary : scheme.onSurface,
              ),
              const SizedBox(width: 6),
              Text(
                selected
                    ? AppLocalizations.of(context).filterPill(label, value!)
                    : label,
                style: TextStyle(
                  color: selected ? scheme.primary : scheme.onSurface,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
