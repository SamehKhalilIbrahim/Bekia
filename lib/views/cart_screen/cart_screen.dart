import 'package:bekia/cubit/hive_cubit/hive_cubit.dart';
import 'package:bekia/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import '../../core/models/product_model/product_model.dart';
import '../../services/constants.dart';
import 'cart_product_card.dart';

class CartScreen extends StatefulWidget {
  final ScrollController scrollController;

  const CartScreen({super.key, required this.scrollController});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Box<Product> cartBox = Hive.box<Product>(HiveConstant.cartProductBox);

  double _calculateTotal(List<Product> products) {
    return products.fold(
      0.0,
      (sum, product) => sum + (product.price * product.quantity),
    );
  }

  int _calculateTotalItems(List<Product> products) {
    return products.fold(0, (sum, product) => sum + product.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HiveCubit, HiveState>(
        builder: (context, state) {
          final cartProducts = cartBox.values.toList();
          final totalPrice = _calculateTotal(cartProducts);
          final totalItems = _calculateTotalItems(cartProducts);

          return CustomScrollView(
            controller: widget.scrollController,
            physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast,
            ),
            slivers: [
              // Cart Items Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: cartProducts.isEmpty
                    ? SliverToBoxAdapter(
                        child: SizedBox(
                          height: context.height * 0.8,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Your Cart is Empty",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Add some products to get started",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final product = cartProducts[index];
                          return CartProductCard(product: product);
                        }, childCount: cartProducts.length),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisExtent: 110,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                      ),
              ),

              // Bottom Summary Section (only show when cart is not empty)
              if (cartProducts.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Divider(thickness: 1),
                        const SizedBox(height: 16),

                        // Total Items
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Items:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '$totalItems',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Total Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Price:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Checkout Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Implement checkout functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Checkout functionality coming soon!',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).primaryColorLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Proceed to Checkout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
