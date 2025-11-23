import 'package:bekia/cubit/hive_cubit/hive_cubit.dart';
import 'package:bekia/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/models/product_model.dart';
import '../../core/ui/themes/font.dart';
import '../home_screen/shimmer/shimmer.dart';

class CartProductCard extends StatelessWidget {
  final Product product;

  const CartProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Stack(
        children: [
          // Product Image
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl[0],
              placeholder: (context, url) =>
                  const ShimmerImage(hight: 95, width: 105),
              filterQuality: FilterQuality.low,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageBuilder: (context, imageProvider) {
                return Hero(
                  tag: 'cart_product_${product.id}',
                  transitionOnUserGestures: true,
                  child: Container(
                    height: 95,
                    width: 105,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: imageProvider,
                        scale: 0.1,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Product Name
          Positioned(
            top: 15,
            left: 115,
            right: 40,
            child: Text(
              product.name,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: Font.semiBold,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Product Price with Quantity
          Positioned(
            bottom: 26,
            left: 115,
            child: Text(
              '\$${product.price}',
              style: const TextStyle(
                fontFamily: Font.semiBold,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 115,
            bottom: 8,
            child: Text(
              'Subtotal: \$${(product.price * product.quantity).toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: Font.semiBold,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
          // Delete Button
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                context.read<HiveCubit>().removeFromCart(product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} removed from cart'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              icon: Icon(Icons.delete_outline, color: Colors.red[400]),
            ),
          ),

          // Quantity Controls
          Positioned(
            bottom: 32,
            right: 0,
            child: BlocBuilder<HiveCubit, HiveState>(
              builder: (context, state) {
                final cubit = context.read<HiveCubit>();
                final quantity = cubit.getProductQuantity(product.id);

                return Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: context.colors.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).primaryColorLight.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Decrease Button
                      IconButton(
                        onPressed: () {
                          cubit.decreaseQuantity(product);
                        },

                        icon: Icon(
                          quantity > 1 ? Icons.remove : Icons.delete_outline,
                          color: quantity > 1
                              ? Theme.of(context).primaryColorLight
                              : Colors.red[400],
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),

                      // Quantity Display
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColorLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          quantity.toString(),
                          style: TextStyle(
                            fontFamily: Font.semiBold,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ),

                      // Increase Button
                      IconButton(
                        onPressed: () {
                          cubit.increaseQuantity(product);
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColorLight,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
