// /workspaces/finqly/lib/widgets/emotion_badge.dart
import 'package:flutter/material.dart';
import 'package:finqly/theme/colors.dart';

/// A pill-shaped badge for showing an emotion/state.
/// - Supports gradient or solid color
/// - Optional icon
/// - Tap ripple via InkWell (optional)
/// - Accessible semantics label
/// - Size presets (sm/md/lg)
class EmotionBadge extends StatelessWidget {
  final String label;
  final IconData? icon;

  /// Use either [gradientColors] (>= 2) or [color] (solid).
  final List<Color>? gradientColors;
  final Color? color;

  /// Called when the badge is tapped. If null, no ripple/interaction.
  final VoidCallback? onTap;

  /// Semantic label for screen readers. Falls back to [label] if null.
  final String? semanticLabel;

  /// Size preset: 'sm' | 'md' | 'lg'
  final String size;

  /// Optional custom padding (overrides size preset padding).
  final EdgeInsetsGeometry? padding;

  /// Optional elevation shadow under the pill.
  final double elevation;

  /// Icon size (uses size preset if null).
  final double? iconSize;

  /// Text style override (color/weight/size can be customized).
  final TextStyle? textStyle;

  /// Optional border (for high-contrast outlines).
  final BorderSide? border;

  const EmotionBadge({
    super.key,
    required this.label,
    this.icon,
    this.gradientColors,
    this.color,
    this.onTap,
    this.semanticLabel,
    this.size = 'md',
    this.padding,
    this.elevation = 0.0,
    this.iconSize,
    this.textStyle,
    this.border,
  }) : assert(
          gradientColors == null || gradientColors.length >= 2,
          'gradientColors must contain at least 2 colors',
        );

  // ---- Size presets ---------------------------------------------------------
  (EdgeInsets, double, double) _metricsForSize() {
    switch (size) {
      case 'sm':
        return (const EdgeInsets.symmetric(horizontal: 14, vertical: 8), 14, 16);
      case 'lg':
        return (const EdgeInsets.symmetric(horizontal: 22, vertical: 12), 16, 22);
      case 'md':
      default:
        return (const EdgeInsets.symmetric(horizontal: 18, vertical: 10), 15, 18);
    }
  }

  // Compute readable text color (white by default for vivid backgrounds).
  Color _effectiveTextColor(BuildContext context) {
    if (textStyle?.color != null) return textStyle!.color!;
    final bg = color ?? gradientColors?.first;
    if (bg == null) return Colors.white;
    return bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final (padDefault, fontSize, iconSz) = _metricsForSize();
    final pad = padding ?? padDefault;
    final txtColor = _effectiveTextColor(context);
    final text = Text(
      label,
      textScaler: MediaQuery.of(context).textScaler, // respects system text scale
      style: (textStyle ??
          TextStyle(
            fontFamily: 'Nunito',
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: txtColor,
          )),
    );

    final decoration = BoxDecoration(
      color: gradientColors == null ? (color ?? Theme.of(context).colorScheme.primary) : null,
      gradient: gradientColors != null
          ? LinearGradient(
              colors: gradientColors!,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      borderRadius: BorderRadius.circular(30),
      boxShadow: elevation > 0
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: elevation * 2,
                offset: Offset(0, elevation / 2),
              ),
            ]
          : null,
      border: border != null ? Border.fromBorderSide(border!) : null,
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: txtColor, size: iconSize ?? iconSz),
          const SizedBox(width: 8),
        ],
        Flexible(child: text),
      ],
    );

    final semanticsLabel = semanticLabel ?? label;

    final badge = Semantics(
      button: onTap != null,
      label: semanticsLabel,
      child: Container(
        padding: pad,
        decoration: decoration,
        child: content,
      ),
    );

    // If not tappable, return plain container (no Material/Ink).
    if (onTap == null) return badge;

    // Tappable with ripple
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: badge,
      ),
    );
  }

  // ---- AppColors-based presets ---------------------------------------------

  /// Energetic / motivated
  factory EmotionBadge.excited(
    String label, {
    IconData? icon,
    VoidCallback? onTap,
    String size = 'md',
  }) {
    return EmotionBadge(
      label: label,
      icon: icon ?? Icons.rocket_launch_rounded,
      gradientColors: const [AppColors.accentPurple, AppColors.primary],
      onTap: onTap,
      size: size,
      elevation: 2,
    );
  }

  /// Positive / hopeful
  factory EmotionBadge.optimistic(
    String label, {
    IconData? icon,
    VoidCallback? onTap,
    String size = 'md',
  }) {
    return EmotionBadge(
      label: label,
      icon: icon ?? Icons.wb_sunny_rounded,
      gradientColors: const [Colors.amber, AppColors.warning],
      onTap: onTap,
      size: size,
      elevation: 2,
    );
  }

  /// Neutral / steady
  factory EmotionBadge.neutral(
    String label, {
    IconData? icon,
    VoidCallback? onTap,
    String size = 'md',
  }) {
    return EmotionBadge(
      label: label,
      icon: icon ?? Icons.balance_rounded,
      gradientColors: const [AppColors.textMuted, AppColors.textSecondary],
      onTap: onTap,
      size: size,
    );
  }

  /// Unsure / puzzled
  factory EmotionBadge.confused(
    String label, {
    IconData? icon,
    VoidCallback? onTap,
    String size = 'md',
  }) {
    return EmotionBadge(
      label: label,
      icon: icon ?? Icons.help_outline_rounded,
      gradientColors: const [Colors.lightBlueAccent, AppColors.accentPurple],
      onTap: onTap,
      size: size,
    );
  }

  /// Concerned / anxious
  factory EmotionBadge.worried(
    String label, {
    IconData? icon,
    VoidCallback? onTap,
    String size = 'md',
  }) {
    return EmotionBadge(
      label: label,
      icon: icon ?? Icons.warning_amber_rounded,
      gradientColors: const [Colors.redAccent, AppColors.danger],
      onTap: onTap,
      size: size,
    );
  }

  /// Careful / defensive
  factory EmotionBadge.cautious(
    String label, {
    IconData? icon,
    VoidCallback? onTap,
    String size = 'md',
  }) {
    return EmotionBadge(
      label: label,
      icon: icon ?? Icons.shield_moon_rounded,
      gradientColors: const [AppColors.primary, AppColors.textSecondary],
      onTap: onTap,
      size: size,
    );
  }
}
