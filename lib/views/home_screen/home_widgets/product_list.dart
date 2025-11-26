import 'package:flutter/material.dart';

import '../../../core/models/product_model/product_model.dart';
import '../../../core/ui/animations/screen_transactions_animation.dart';
import '../product/product_card.dart';
import '../product/product_info.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = products[index];
          return InkWell(
            onTap: () {
              Navigator.of(
                context,
              ).push(FadePageRoute(page: ProductInfo(product: product)));
            },
            child: ProductCard(product: product),
          );
        }, childCount: products.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 240,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
      ),
    );
  }
}
