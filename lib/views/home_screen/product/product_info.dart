import 'dart:ui';

import 'package:bekia/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../cubit/hive_cubit/hive_cubit.dart';
import '../../../core/models/product_model.dart';
import '../../../services/constants.dart';
import '../../../core/ui/themes/font.dart';
import '../shimmer/shimmer.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  ProductInfo({super.key, required this.product});

  final ValueNotifier<int> selectedImageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    List images = product.imageUrl;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor.withOpacity(0.2),
        actions: [
          BlocBuilder<HiveCubit, HiveState>(
            builder: (context, state) {
              bool isFavorite = context.read<HiveCubit>().isProductFavorite(
                product.id,
              );

              return IconButton(
                onPressed: () {
                  context.read<HiveCubit>().changeFavoriteState(product);
                },
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 26,
                  color: Theme.of(context).primaryColorLight,
                ),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: selectedImageNotifier,
                    builder: (context, selectedImage, child) {
                      final safeSelectedImage = selectedImage < images.length
                          ? selectedImage
                          : 0;

                      return Container(
                        height: images.length == 1
                            ? context.height / 2.4
                            : context.height / 2,
                        width: context.width,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).cardColor.withValues(alpha: 0.2),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            if (images.isNotEmpty)
                              Hero(
                                tag: "product_${product.id}",
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  height: context.height / 2.6,
                                  child: CachedNetworkImage(
                                    imageUrl: images[safeSelectedImage],
                                    placeholder: (context, url) =>
                                        const ShimmerImage(
                                          hight: 150,
                                          width: 200,
                                        ),
                                    filterQuality: FilterQuality.low,
                                    imageBuilder: (context, imageProvider) {
                                      return Image(
                                        image: imageProvider,
                                        filterQuality: FilterQuality.low,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            if (images.length > 1)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: images.map((image) {
                                  final index = images.indexOf(image);
                                  return GestureDetector(
                                    onTap: () {
                                      selectedImageNotifier.value = index;
                                    },
                                    child: Container(
                                      height: context.height / 13.5,
                                      width: context.width / 6.5,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      decoration: safeSelectedImage == index
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                width: 0.5,
                                                color: Theme.of(
                                                  context,
                                                ).primaryColorLight,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColorLight,
                                                  blurRadius: 15,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              color: Colors.white,
                                            )
                                          : BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.white,
                                            ),
                                      child: CachedNetworkImage(
                                        imageUrl: image,
                                        placeholder: (context, url) =>
                                            ShimmerImage(
                                              hight: context.height / 13.5,
                                              width: context.width / 6.5,
                                              borderRadius: 12,
                                            ),
                                        filterQuality: FilterQuality.low,
                                        imageBuilder: (context, imageProvider) {
                                          return Image(
                                            image: imageProvider,
                                            filterQuality: FilterQuality.low,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: SizedBox(
                      width: context.width,
                      height: context.height / 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontFamily: Font.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Description:",
                                style: TextStyle(
                                  fontFamily: Font.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                height: 27,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.rating.toString(),
                                      style: const TextStyle(
                                        fontFamily: Font.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Icon(
                                      Icons.star_rate_rounded,
                                      color: Theme.of(
                                        context,
                                      ).primaryColorLight,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                product.description,
                                style: const TextStyle(
                                  fontFamily: Font.semiBold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget bottomBar(BuildContext context) {
    return Positioned(
      bottom: 5,
      left: 5,
      right: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            width: 200,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).cardColor,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.transparent,
                BlendMode.srcOver,
              ),
              child: SizedBox(
                height: 60,
                child: BlocBuilder<HiveCubit, HiveState>(
                  builder: (context, state) {
                    final cubit = context.read<HiveCubit>();
                    final isInCart = cubit.isProductInCart(product.id);
                    final quantity = cubit.getProductQuantity(product.id);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Price:",
                              style: TextStyle(
                                fontFamily: Font.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "\$${product.price.toString()}",
                              style: TextStyle(
                                fontFamily: Font.semiBold,
                                fontSize: 20,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                          ],
                        ),

                        // Add to Cart or Quantity Controls
                        isInCart
                            ? _buildQuantityControls(context, cubit, quantity)
                            : _buildAddToCartButton(context, cubit),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Add to Cart Button (when product is not in cart)
  Widget _buildAddToCartButton(BuildContext context, HiveCubit cubit) {
    return ElevatedButton(
      onPressed: () {
        cubit.addToCart(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} added to cart'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).primaryColorLight,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColorLight,
        minimumSize: Size(context.width * 0.5, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: const Text(
        'Add To Cart',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Quantity Controls (when product is already in cart)
  // Quantity Controls (when product is already in cart)
  Widget _buildQuantityControls(
    BuildContext context,
    HiveCubit cubit,
    int quantity,
  ) {
    return Container(
      width: context.width * 0.47, // Reduced from 0.5 to 0.48
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).primaryColorLight.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Decrease Button
          SizedBox(
            width: 40,
            child: IconButton(
              onPressed: () {
                cubit.decreaseQuantity(product);
                if (quantity == 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} removed from cart'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              icon: Icon(
                quantity > 1 ? Icons.remove : Icons.delete_outline,
                color: quantity > 1
                    ? Theme.of(context).primaryColorLight
                    : Colors.red[400],
                size: 22,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

          // Quantity Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  quantity.toString(),
                  style: TextStyle(
                    fontFamily: Font.bold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
                Text(
                  'in cart',
                  style: TextStyle(
                    fontFamily: Font.bold,
                    fontSize: 14,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ],
            ),
          ),

          // Increase Button
          SizedBox(
            width: 40,
            child: IconButton(
              onPressed: () {
                cubit.increaseQuantity(product);
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).primaryColorLight,
                size: 22,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
