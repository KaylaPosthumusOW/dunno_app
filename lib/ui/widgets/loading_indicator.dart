import 'package:dunno/constants/themes.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final String? message;
  final Color? textColor;

  const LoadingIndicator({super.key, this.color, this.message, this.textColor});

  @override
  Widget build(BuildContext context) {
    if (message != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 3, color: color ?? AppColors.cinnabar),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(message ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor ?? AppColors.cinnabar)),
            ],
          ],
        ),
      );
    }
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>((color != null) ? color! : AppColors.cinnabar),
        strokeWidth: 1,
      ),
    );
  }
}
