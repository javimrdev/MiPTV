import 'package:flutter/material.dart';
import 'package:miptv/core/platform/app_platform.dart';
import 'package:miptv/core/widgets/glass/glass_surface.dart';
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
    final chip = ActionChip(
      avatar: Icon(selected ? Icons.check : Icons.expand_more, size: 18),
      label: Text(
        selected ? AppLocalizations.of(context).filterPill(label, value!) : label,
      ),
      onPressed: onTap,
      backgroundColor: isIOSGlass
          ? Colors.transparent
          : (selected ? Theme.of(context).colorScheme.secondaryContainer : null),
    );

    if (!isIOSGlass) return chip;

    return GlassSurface(
      borderRadius: BorderRadius.circular(20),
      tintAlpha: selected ? 0.85 : 0.55,
      child: chip,
    );
  }
}
