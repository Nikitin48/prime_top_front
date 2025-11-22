import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';

class IconWithLabel extends StatefulWidget {
  const IconWithLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<IconWithLabel> createState() => _IconWithLabelState();
}

class _IconWithLabelState extends State<IconWithLabel> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Colors.white;
    final Color hoverColor = Color.lerp(Colors.white, ColorName.primary, 0.35)!;
    final Color currentColor = _isHovered ? hoverColor : baseColor;
    final Color hoverBg = _isHovered ? Colors.white.withOpacity(0.12) : Colors.transparent;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: hoverBg,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: currentColor),
              const SizedBox(height: 2),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: currentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
