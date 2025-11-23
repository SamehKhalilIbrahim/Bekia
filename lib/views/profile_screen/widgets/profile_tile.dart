import 'package:bekia/main.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final Icon? icon;
  final Widget? suffixWidget;
  final String title;
  final VoidCallback onTap;
  final double virticalPadding;

  const ProfileTile({
    super.key,
    this.icon,
    required this.title,
    required this.onTap,
    this.suffixWidget,
    this.virticalPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: virticalPadding,
        ),
        decoration: BoxDecoration(
          color: context.colors.cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            if (icon != null) icon!,
            if (icon != null) SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            suffixWidget ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: context.colors.textTheme.bodyMedium?.color,
                ),
          ],
        ),
      ),
    );
  }
}
