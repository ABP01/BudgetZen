import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'skeleton_loader.dart';

class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppColors.white,
                ),
              ),
      ),
    );
  }
}

class LoadingCard extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Widget? skeletonWidget;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const LoadingCard({
    super.key,
    required this.child,
    this.isLoading = false,
    this.skeletonWidget,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isLoading
          ? (skeletonWidget ??
                const SkeletonContainer(width: double.infinity, height: 60))
          : child,
    );
  }
}

class LoadingText extends StatelessWidget {
  final String text;
  final bool isLoading;
  final TextStyle? style;
  final double skeletonWidth;
  final double skeletonHeight;

  const LoadingText({
    super.key,
    required this.text,
    this.isLoading = false,
    this.style,
    this.skeletonWidth = 100,
    this.skeletonHeight = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SkeletonContainer(width: skeletonWidth, height: skeletonHeight);
    }

    return Text(text, style: style);
  }
}

class LoadingAvatar extends StatelessWidget {
  final String? imageUrl;
  final IconData? icon;
  final bool isLoading;
  final double size;
  final Color? backgroundColor;

  const LoadingAvatar({
    super.key,
    this.imageUrl,
    this.icon,
    this.isLoading = false,
    this.size = 40,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SkeletonContainer(
        width: size,
        height: size,
        borderRadius: BorderRadius.circular(size / 2),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryExtraLight,
        borderRadius: BorderRadius.circular(size / 2),
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null
          ? Icon(
              icon ?? Icons.person,
              size: size * 0.6,
              color: AppColors.primary,
            )
          : null,
    );
  }
}

class LoadingListTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool isLoading;
  final VoidCallback? onTap;

  const LoadingListTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (leading != null)
              const SkeletonContainer(width: 40, height: 40)
            else
              SkeletonContainer(
                width: 40,
                height: 40,
                borderRadius: BorderRadius.circular(20),
              ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonContainer(width: 120, height: 16),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    const SkeletonContainer(width: 80, height: 12),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            if (trailing != null)
              const SkeletonContainer(width: 60, height: 16),
          ],
        ),
      );
    }

    return ListTile(
      leading: leading,
      title: title != null ? Text(title!) : null,
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class LoadingGrid extends StatelessWidget {
  final List<Widget> children;
  final bool isLoading;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final Widget skeletonItem;
  final int skeletonCount;

  const LoadingGrid({
    super.key,
    required this.children,
    this.isLoading = false,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    required this.skeletonItem,
    this.skeletonCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
        ),
        itemCount: skeletonCount,
        itemBuilder: (context, index) => skeletonItem,
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      children: children,
    );
  }
}
