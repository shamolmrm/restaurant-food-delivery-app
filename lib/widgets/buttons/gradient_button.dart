import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final double borderRadius;
  final List<Color>? colors;
  final TextStyle? textStyle;
  final Widget? prefix;
  final Widget? suffix;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = AppDimensions.buttonHeight,
    this.borderRadius = AppDimensions.buttonRadius,
    this.colors,
    this.textStyle,
    this.prefix,
    this.suffix,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors ??
        [AppColors.primary, AppColors.primaryLight];
    final isDisabled = widget.onPressed == null && !widget.isLoading;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => _controller.forward(),
      onTapUp: isDisabled ? null : (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.isLoading || isDisabled ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDisabled
                  ? [Colors.grey.shade300, Colors.grey.shade400]
                  : colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: colors.first.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.prefix != null) ...[
                        widget.prefix!,
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: widget.textStyle ??
                            AppTextStyles.labelLarge.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                      ),
                      if (widget.suffix != null) ...[
                        const SizedBox(width: 8),
                        widget.suffix!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
