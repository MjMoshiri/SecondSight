import 'package:flutter/material.dart';

/// The signature progress bar: one track split into [sections] visual
/// segments. Purely cosmetic — the fill just flows across segment gaps.
class SegmentedBar extends StatelessWidget {
  final double ratio; // 0..1
  final int sections;
  final Color color;
  final double height;

  const SegmentedBar({
    super.key,
    required this.ratio,
    required this.sections,
    required this.color,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < sections; i++) ...[
          if (i > 0) const SizedBox(width: 5),
          Expanded(child: _segment(i)),
        ],
      ],
    );
  }

  Widget _segment(int i) {
    // How full this segment is: ratio mapped onto [i/n, (i+1)/n].
    final fill = (ratio * sections - i).clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Container(
        height: height,
        color: color.withValues(alpha: 0.14),
        alignment: Alignment.centerLeft,
        child: AnimatedFractionallySizedBox(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          widthFactor: fill,
          heightFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.75), color],
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
