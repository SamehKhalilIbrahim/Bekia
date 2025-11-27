import 'package:bekia/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../home_screen/shimmer/shimmer.dart';

class CirclerProfileImage extends StatelessWidget {
  final bool showBorder;
  final String? image;
  const CirclerProfileImage({super.key, this.showBorder = true, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 124,
      height: 124,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                strokeAlign: BorderSide.strokeAlignOutside,
                color: context.colors.scaffoldBackgroundColor,
                width: 5,
              )
            : null,
      ),
      child: ClipOval(
        child: image == null
            ? Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.cardColor.withOpacity(0.2),
                ),
                child: Icon(
                  FluentIcons.person_48_regular,
                  size: 62,
                  color: context.colors.primaryColorLight,
                ),
              )
            : CachedNetworkImage(
                imageUrl: image!,
                fit: BoxFit.cover,
                width: 124,
                height: 124,
                placeholder: (context, url) => ShimmerImage(
                  width: 124,
                  hight: 124,
                  borderRadius: 62, // Make it circular
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
      ),
    );
  }
}
