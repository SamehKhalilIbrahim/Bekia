import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:bekia/main.dart';
import '../../core/models/product_model.dart';
import '../../services/constants.dart';
import 'wishlist_product_card.dart';

class WishlistScreen extends StatefulWidget {
  final ScrollController scrollController;

  const WishlistScreen({super.key, required this.scrollController});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Product>? favProducts;
  final Box<Product> favoritesBox = Hive.box<Product>(
    HiveConstant.favoritesProductBox,
  );

  @override
  void initState() {
    super.initState();
    favProducts = favoritesBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.fast,
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          sliver: favProducts!.isEmpty
              ? SliverToBoxAdapter(
                  child: SizedBox(
                    height: context.height,
                    child: const Center(
                      child: Text("You Don't have Wishlist Products"),
                    ),
                  ),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = favProducts![index];
                    return FavouriteProductCard(product: product);
                  }, childCount: favProducts!.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: 120,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                ),
        ),
      ],
    );
  }
}
