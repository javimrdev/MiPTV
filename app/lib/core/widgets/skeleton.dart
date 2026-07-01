// Reusable loading skeletons that mirror the real list tiles so the layout
// does not shift (CLS) when data arrives.
//
// A single AnimationController per list drives a soft opacity pulse for all
// cells (see _SkeletonScope); individual SkeletonBoxes just read the shared
// animation value. Honours MediaQueryData.disableAnimations for accessibility
// by showing a steady opacity instead of pulsing.
import 'package:flutter/material.dart';
import 'package:miptv/core/responsive/grid_delegates.dart';

const double _kHorizontalPadding = 16;

/// A grey placeholder block that pulses opacity in sync with its [SkeletonList]
/// ancestor.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4,
    this.circular = false,
  });

  final double width;
  final double height;
  final double borderRadius;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.onSurface;
    final animation = _SkeletonScope.of(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: animation.value),
            borderRadius: circular ? null : BorderRadius.circular(borderRadius),
            shape: circular ? BoxShape.circle : BoxShape.rectangle,
          ),
        );
      },
    );
  }
}

/// Skeleton mimicking the layout of a [ListTile]: leading thumbnail, a title
/// bar, and an optional trailing square (e.g. the favourite star).
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({
    super.key,
    required this.height,
    required this.leadingSize,
    this.leadingCircular = false,
    this.showTrailing = false,
  });

  final double height;
  final double leadingSize;
  final bool leadingCircular;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
        child: Row(
          children: [
            SkeletonBox(
              width: leadingSize,
              height: leadingSize,
              circular: leadingCircular,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: SkeletonBox(width: double.infinity, height: 16),
            ),
            if (showTrailing) ...[
              const SizedBox(width: 16),
              const SkeletonBox(width: 24, height: 24),
            ],
          ],
        ),
      ),
    );
  }
}

/// A virtualised list of [SkeletonListTile]s whose [itemExtent] matches the real
/// list, wrapped in a [_SkeletonScope] that owns the shared pulse animation.
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    required this.itemExtent,
    required this.leadingSize,
    this.itemCount = 12,
    this.leadingCircular = false,
    this.showTrailing = false,
  });

  /// Home / VOD categories: short tiles with a small circular leading icon.
  const SkeletonList.categories({super.key})
    : itemExtent = 56,
      leadingSize = 40,
      itemCount = 12,
      leadingCircular = true,
      showTrailing = false;

  /// Live channels: 72px tiles with a 48px logo and a trailing star.
  const SkeletonList.streams({super.key})
    : itemExtent = 72,
      leadingSize = 48,
      itemCount = 12,
      leadingCircular = false,
      showTrailing = true;

  /// VOD movies (search results / category): 72px tiles with a 48px poster.
  const SkeletonList.movies({super.key})
    : itemExtent = 72,
      leadingSize = 48,
      itemCount = 12,
      leadingCircular = false,
      showTrailing = false;

  final double itemExtent;
  final double leadingSize;
  final int itemCount;
  final bool leadingCircular;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return _SkeletonScope(
      child: ListView.builder(
        itemCount: itemCount,
        itemExtent: itemExtent,
        itemBuilder: (_, __) => SkeletonListTile(
          height: itemExtent,
          leadingSize: leadingSize,
          leadingCircular: leadingCircular,
          showTrailing: showTrailing,
        ),
      ),
    );
  }
}

/// Skeleton mimicking [MovieGridTile]'s layout: a poster-shaped block above
/// a title bar.
class SkeletonGridTile extends StatelessWidget {
  const SkeletonGridTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: SkeletonBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 12,
            ),
          ),
          const SizedBox(height: 8),
          const SkeletonBox(width: double.infinity, height: 14),
        ],
      ),
    );
  }
}

/// Grid counterpart to [SkeletonList], sharing the exact same cell geometry
/// ([postersGridDelegate]) as the real poster grid so loading states don't
/// visibly jump between list and grid shapes.
class SkeletonGrid extends StatelessWidget {
  const SkeletonGrid({super.key, this.itemCount = 12});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return _SkeletonScope(
      child: GridView.builder(
        gridDelegate: postersGridDelegate(),
        itemCount: itemCount,
        itemBuilder: (_, __) => const SkeletonGridTile(),
      ),
    );
  }
}

/// Owns a single [AnimationController] and exposes the current pulse opacity to
/// descendant [SkeletonBox]es via an inherited [Animation].
class _SkeletonScope extends StatefulWidget {
  const _SkeletonScope({required this.child});

  final Widget child;

  static Animation<double> of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_SkeletonInherited>();
    assert(scope != null, 'SkeletonBox must be a descendant of a SkeletonList');
    return scope!.animation;
  }

  @override
  State<_SkeletonScope> createState() => _SkeletonScopeState();
}

class _SkeletonScopeState extends State<_SkeletonScope>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = Tween<double>(
      begin: 0.25,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SkeletonInherited(animation: _animation, child: widget.child);
  }
}

class _SkeletonInherited extends InheritedWidget {
  const _SkeletonInherited({required this.animation, required super.child});

  final Animation<double> animation;

  @override
  bool updateShouldNotify(_SkeletonInherited oldWidget) =>
      animation != oldWidget.animation;
}
