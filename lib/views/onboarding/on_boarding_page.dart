import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/ui/animations/fade_animation.dart';

class OnboardingScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeAnimation(
            delay: 0.2,
            child: SvgPicture.asset(imagePath, height: 300),
          ),
          const SizedBox(height: 20),
          FadeAnimation(
            delay: 0.3,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          FadeAnimation(
            delay: 0.4,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
