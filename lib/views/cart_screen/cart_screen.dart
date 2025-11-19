import 'package:bekia/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../core/models/product_model.dart';
import '../../services/constants.dart';
import 'cart_product_card.dart';

class CartScreen extends StatefulWidget {
  final ScrollController scrollController;

  const CartScreen({super.key, required this.scrollController});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product>? cartProducts;

  final Box<Product> cartBox = Hive.box<Product>(HiveConstant.cartProductBox);

  @override
  void initState() {
    super.initState();
    cartProducts = cartBox.values.toList();
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
          sliver: cartProducts!.isEmpty
              ? SliverToBoxAdapter(
                  child: SizedBox(
                    height: context.height,
                    child: const Center(
                      child: Text("Don't have Products In Your Cart"),
                    ),
                  ),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = cartProducts![index];
                    return CartProductCard(product: product);
                  }, childCount: cartProducts!.length),
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
