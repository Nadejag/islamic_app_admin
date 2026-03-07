part of 'dashboard_page.dart';

class _AnimatedCounter extends StatelessWidget {
  const _AnimatedCounter({required this.value, this.fontSize = 48});

  final int value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 1300),
      curve: Curves.easeOutCubic,
      builder: (context, val, _) {
        return Text(
          val.toInt().toString(),
          style: TextStyle(color: AppColors.white, fontSize: fontSize, fontWeight: FontWeight.w700),
        );
      },
    );
  }
}

class _AnimatedBar extends StatelessWidget {
  const _AnimatedBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: v,
            minHeight: 7,
            backgroundColor: const Color(0xFF315045),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        );
      },
    );
  }
}

class _HealthRow extends StatelessWidget {
  const _HealthRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: AppColors.white, fontSize: 14)),
        const Spacer(),
        Text(value, style: const TextStyle(color: AppColors.green, fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class AppColors {
  static const bg = Color(0xFF031D15);
  static const sidebar = Color(0xFF07261D);
  static const stroke = Color(0xFF1A4B39);
  static const strokeBright = Color(0xFF2A5F4B);
  static const white = Color(0xFFEAF4EE);
  static const muted = Color(0xFF86A79A);
  static const item = Color(0xFF8CA89C);
  static const iconMuted = Color(0xFF7A988D);
  static const green = Color(0xFF1FF08D);
  static const searchHint = Color(0xFF6F8E83);
}

const TextStyle tableHeadStyle = TextStyle(
  color: Color(0xFF7A988B),
  fontSize: 12,
  fontWeight: FontWeight.w600,
  height: 1.2,
  letterSpacing: .2,
);
