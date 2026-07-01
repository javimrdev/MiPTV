import 'package:flutter/material.dart';
import 'package:miptv/core/platform/app_platform.dart';
import 'package:miptv/core/widgets/glass/crystal_glass.dart';

/// A search text field shared across screens (Home, Movies).
///
/// On Android/web/desktop this renders a plain outlined [TextField] — the
/// existing look, untouched. On iOS it renders the same field with no border
/// on a transparent background, wrapped in [CrystalGlass].
class CrystalSearchField extends StatelessWidget {
  const CrystalSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.showClear,
    required this.onClear,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final bool showClear;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final suffixIcon = showClear
        ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
        : null;

    if (!isIOSGlass) {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: onChanged,
      );
    }

    return CrystalGlass(
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          isDense: true,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
