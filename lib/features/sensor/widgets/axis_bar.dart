import 'package:flutter/material.dart';

/// Barra horizontal centrada em zero (-20 a +20 m/s²) + valor numérico.
class AxisBar extends StatelessWidget {
  const AxisBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const maxAbs = 20.0;
    final scheme = Theme.of(context).colorScheme;
    final frac = (value.abs() / maxAbs).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(label, style: Theme.of(context).textTheme.titleLarge),
          ),
          Expanded(
            child: SizedBox(
              height: 22,
              child: LayoutBuilder(
                builder: (_, c) {
                  final half = c.maxWidth / 2;
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Positioned(
                        left: value >= 0 ? half : half - half * frac,
                        width: half * frac,
                        top: 0,
                        bottom: 0,
                        child: Container(color: color),
                      ),
                      Positioned(
                        left: half - 1,
                        width: 2,
                        top: 0,
                        bottom: 0,
                        child: Container(color: scheme.outline),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              value.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFeatures: [FontFeature.tabularFigures()],
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
