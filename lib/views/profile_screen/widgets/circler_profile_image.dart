import 'package:bekia/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CirclerProfileImage extends StatelessWidget {
  final bool showBorder;
  final String? image;
  const CirclerProfileImage({super.key, this.showBorder = true, this.image});

  @override
  Widget build(BuildContext context) {
    print(image);
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
        image: image == null
            ? DecorationImage(
                image: AssetImage("assets/images/profile.jpg"),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: image != null
          ? CachedNetworkImage(
              imageUrl: image!,
              fit: BoxFit.cover,
              width: 124,
              height: 124,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : null,
    );
  }
}
