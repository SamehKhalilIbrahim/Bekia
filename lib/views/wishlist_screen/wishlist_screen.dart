import 'package:bekia/cubit/hive_cubit/hive_cubit.dart';
import 'package:bekia/main.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  final Box<Product> favoritesBox = Hive.box<Product>(
    HiveConstant.favoritesProductBox,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HiveCubit, HiveState>(
        builder: (context, state) {
          final favProducts = favoritesBox.values.toList();

          return CustomScrollView(
            controller: widget.scrollController,
            physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast,
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: favProducts.isEmpty
                    ? SliverToBoxAdapter(
                        child: SizedBox(
                          height: context.height * 0.8,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FluentIcons.board_heart_24_filled,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Your Wishlist is Empty",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Add your favorite products to get started",
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
                          final product = favProducts[index];
                          return FavoriteProductCard(
                            product: product,
                            onDelete: () {
                              context.read<HiveCubit>().changeFavoriteState(
                                product,
                              );
                            },
                          );
                        }, childCount: favProducts.length),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisExtent: 120,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
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
