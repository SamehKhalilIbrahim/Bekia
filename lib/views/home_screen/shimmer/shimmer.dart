import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerImage extends StatelessWidget {
  final double width;
  final double hight;
  final double borderRadius;

  const ShimmerImage({
    super.key,
    required this.width,
    required this.hight,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black.withOpacity(0.20),
      highlightColor: Colors.transparent,
      child: Container(
        height: hight,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}

class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            const ShimmerImage(hight: 150, width: 200),
            Positioned(
              top: 170,
              left: 10,
              child: Shimmer.fromColors(
                baseColor: Colors.black.withOpacity(0.20),
                highlightColor: Colors.transparent,
                child: Container(
                  height: 20,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Shimmer.fromColors(
                  baseColor: Colors.black.withOpacity(0.20),
                  highlightColor: Colors.transparent,
                  child: Container(
                    height: 20,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerCategoryCard extends StatelessWidget {
  const ShimmerCategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Shimmer.fromColors(
          baseColor: Colors.black.withOpacity(0.20),
          highlightColor: Colors.transparent,
          child: Container(
            height: 30,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
