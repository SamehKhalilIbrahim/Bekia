import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/hive_cubit/hive_cubit.dart';
import '../../../core/models/product_model/product_model.dart';
import '../../../core/ui/themes/font.dart';
import '../shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
          child: CachedNetworkImage(
            imageUrl: product.thumbnail!,
            placeholder: (context, url) =>
                const ShimmerImage(hight: 150, width: 200),
            filterQuality: FilterQuality.low,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageBuilder: (context, imageProvider) {
              return Hero(
                tag: 'product_${product.id}',
                transitionOnUserGestures: true,
                child: Container(
                  height: 150,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: imageProvider,
                      scale: 0.1,

                      filterQuality: FilterQuality.low, // Image quality
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 165,
          left: 10,
          right: 10,
          child: Text(
            product.name,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: Font.semiBold,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Text(
            '\$${product.price}',
            style: const TextStyle(
              fontFamily: Font.semiBold,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: 3,
          right: 3,
          child: BlocBuilder<HiveCubit, HiveState>(
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
        ),
      ],
    );
  }
}
