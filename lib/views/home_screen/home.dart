import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../cubit/product_cubit/product_cubit_cubit.dart';
import '../../cubit/category_cubit/category_cubit.dart'; // New Cubit for category selection

import '../../ui/themes/app_color.dart';
import '../../ui/themes/font.dart';
import 'home_widgets/product_list.dart';
import 'search/search_delegate.dart';
import 'shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  final ScrollController scrollController;

  const HomeScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.fast,
      ),
      slivers: [
        const Appbar(),
        const SearchWidget(),
        Banner(),
        const CategoryList(),
        const ProductGrid(),
      ],
    );
  }
}

class Appbar extends StatelessWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      leading: SvgPicture.asset("assets/images/icons/cart.svg"),
      leadingWidth: 40,
      titleSpacing: 5,
      title: const Text(
        "Bekia",
        style: TextStyle(
          fontFamily: Font.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var productCubit = BlocProvider.of<ProductCubit>(context);
    productCubit.fetchAllProducts();
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          children: [
            Expanded(
                flex: 6,
                child: InkWell(
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(
                          searchItems: productCubit.products),
                    );
                  },
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.externalColor,
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 15),
                        Icon(Icons.search, size: 23),
                        SizedBox(width: 15),
                        Text('Search your product'),
                      ],
                    ),
                  ),
                )),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.externalColor,
                ),
                child: const Icon(Icons.filter_alt, size: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Banner extends StatelessWidget {
  final PageController controllerPage = PageController();

  Banner({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SizedBox(
              height: 190,
              child: PageView(
                controller: controllerPage,
                scrollDirection: Axis.horizontal,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SvgPicture.asset(
                      "assets/images/icons/banner1.svg",
                      fit: BoxFit.fitWidth,
                      width: 1280,
                      height: 720,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/icons/black.png",
                      width: 1280,
                      height: 720,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/icons/sale.png",
                      width: 1280,
                      height: 720,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/icons/image.png",
                      width: 1280,
                      height: 720,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SmoothPageIndicator(
            controller: controllerPage,
            count: 4,
            effect: WormEffect(
              dotHeight: 9,
              dotWidth: 9,
              activeDotColor: Theme.of(context).primaryColorLight,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, categoryState) {
        List<String> categories = [];
        String selectedCategory = "All";

        if (categoryState is CategoryLoading) {
          return SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const ShimmerCategoryCard();
                },
              ),
            ),
          );
        } else if (categoryState is CategoryLoaded) {
          categories = categoryState.categories;
          selectedCategory = context.read<CategoryCubit>().selectedCategory;
          context
              .read<ProductCubit>()
              .fetchProducts(category: selectedCategory);
        } else if (categoryState is CategorySelected) {
          categories = categoryState.categories;
          selectedCategory = categoryState.selectedCategory;
        } else if (categoryState is CategoryError) {
          return Center(child: Text('Error: ${categoryState.message}'));
        }

        if (categories.isEmpty) {
          return const Center(child: Text('No categories available'));
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;

                  return GestureDetector(
                    onTap: () {
                      if (!isSelected) {
                        context.read<CategoryCubit>().selectCategory(category);
                        context
                            .read<ProductCubit>()
                            .fetchProducts(category: category);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            fontFamily: Font.semiBold,
                            fontSize: 14,
                            color: isSelected
                                ? Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .color
                                : Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductCubitState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const ShimmerProductCard(),
                childCount: 4,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 240,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
            ),
          );
        } else if (state is ProductError) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${state.message}')),
          );
        } else if (state is ProductsLoaded) {
          if (state.products.isEmpty) {
            return const SliverToBoxAdapter(
              child: Center(child: Text('No products found')),
            );
          }
          return ProductList(products: state.products);
        } else {
          return const SliverToBoxAdapter(
            child: Center(child: Text('No products found')),
          );
        }
      },
    );
  }
}
