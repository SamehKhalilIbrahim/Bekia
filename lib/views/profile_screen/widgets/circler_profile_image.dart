import 'package:bekia/main.dart';
import 'package:flutter/material.dart';

class CirclerProfileImage extends StatelessWidget {
  final bool showBorder;
  const CirclerProfileImage({super.key, this.showBorder = true});

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
        image: const DecorationImage(
          image: AssetImage("assets/images/profile.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
