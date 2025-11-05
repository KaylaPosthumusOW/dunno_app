import 'package:dunno/constants/themes.dart';
import 'package:flutter/material.dart';

class CustomHeaderBar extends StatelessWidget {
  final VoidCallback? onBack;
  final String? title;
  final String? subtitle;
  final Color? backgroundColor;
  final Color? backButtonColor;
  final Color? iconColor;
  final List<Widget>? actions;

  const CustomHeaderBar({
    super.key,
    this.onBack,
    this.title,
    this.subtitle,
    this.backgroundColor,
    this.backButtonColor,
    this.iconColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: SafeArea(
        maintainBottomViewPadding: false,
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: onBack ?? () => Navigator.of(context).maybePop(),
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Container(
                        padding: const EdgeInsets.only(left: 8, right: 10, top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: backButtonColor,
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: iconColor,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  if (actions != null && actions!.isNotEmpty)
                    Row(mainAxisSize: MainAxisSize.min, children: actions!)
                  else
                    const SizedBox.shrink(),
                ],
              ),

              const SizedBox(height: 12),

              if ((title ?? '').isNotEmpty)
                Text(
                  title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),

              if ((subtitle ?? '').isNotEmpty) ...[
                const SizedBox(height: 6),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.black),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
