import 'package:bekia/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
            ? Image.asset(
                "assets/images/profile.jpg",
                fit: BoxFit.cover,
                width: 124,
                height: 124,
              )
            : CachedNetworkImage(
                imageUrl: image!,
                fit: BoxFit.cover,
                width: 124,
                height: 124,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: context.colors.primaryColorLight,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
      ),
    );
  }
}
