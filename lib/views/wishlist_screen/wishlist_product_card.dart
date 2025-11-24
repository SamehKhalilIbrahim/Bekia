import 'package:bekia/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../../core/models/product_model.dart';
import '../../core/ui/themes/font.dart';
import '../../services/constants.dart';
import '../home_screen/shimmer/shimmer.dart';

class FavoriteProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  FavoriteProductCard({
    super.key,
    required this.product,
    required this.onDelete,
  });
  final Box<Product> favoritesBox = Hive.box<Product>(
    HiveConstant.favoritesProductBox,
  );
  final Box<Product> cartBox = Hive.box<Product>(HiveConstant.cartProductBox);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl[0],
              placeholder: (context, url) =>
                  const ShimmerImage(hight: 110, width: 140),
              filterQuality: FilterQuality.low,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageBuilder: (context, imageProvider) {
                return Hero(
                  tag: 'product_${product.id}',
                  transitionOnUserGestures: true,
                  child: Container(
                    height: 110,
                    width: 140,
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
          Positioned(
            top: 15,
            left: 155,
            right: 40,
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
            top: 75,
            left: 155,
            right: 10,
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
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.close_rounded,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: cartBox.listenable(),
            builder: (context, Box<Product> box, _) {
              bool isInCart = box.containsKey(product.id);

              return Positioned(
                bottom: 15,
                right: 0,
                child: SizedBox(
                  width: 132,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isInCart) {
                        cartBox.delete(product.id);
                      } else {
                        cartBox.put(product.id, product.copyWith());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInCart
                          ? context.colors.cardColor
                          : Theme.of(context).primaryColorLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isInCart ? "Remove from Cart" : "Add to Cart",
                      style: TextStyle(
                        color: context.colors.textTheme.headlineLarge!.color,
                        fontSize: isInCart ? 10 : 12,
                        fontFamily: Font.semiBold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
