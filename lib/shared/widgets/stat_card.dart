import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    this.value,
    this.numericValue,
    this.numberPrefix = '',
    this.numberSuffix = '',
    this.icon = Icons.analytics_outlined,
    this.trendLabel,
    this.accentColor = const Color(0xFF0B6B46),
  });

  final String label;
  final String? value;
  final double? numericValue;
  final String numberPrefix;
  final String numberSuffix;
  final IconData icon;
  final String? trendLabel;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withAlpha(26),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                const Spacer(),
                if (trendLabel != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      trendLabel!,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            _AnimatedMetric(
              value: value,
              numericValue: numericValue,
              prefix: numberPrefix,
              suffix: numberSuffix,
            ),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _AnimatedMetric extends StatelessWidget {
  const _AnimatedMetric({
    required this.value,
    required this.numericValue,
    required this.prefix,
    required this.suffix,
  });

  final String? value;
  final double? numericValue;
  final String prefix;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    if (numericValue == null) {
      return Text(value ?? '-',
          style: Theme.of(context).textTheme.headlineSmall);
    }

    final hasDecimals = numericValue! % 1 != 0;
    final formatter =
        hasDecimals ? NumberFormat('#,##0.0') : NumberFormat('#,##0');
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: numericValue),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOutCubic,
      builder: (context, current, _) {
        final numberText = formatter.format(current);
        return Text(
          '$prefix$numberText$suffix',
          style: Theme.of(context).textTheme.headlineSmall,
        );
      },
    );
  }
}
