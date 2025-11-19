import 'package:flutter/material.dart';

import '../../../models/product_model.dart';

import '../home_widgets/product_list.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Product> searchItems;

  CustomSearchDelegate({required this.searchItems});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return (IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back)));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Product> matchQuery = [];
    for (var product in searchItems) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }
    return CustomScrollView(
      slivers: [
        ProductList(
          products: matchQuery,
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> matchQuery = [];
    for (var product in searchItems) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }

    if (query.isEmpty) {
      return const Center(
        child: Text('Type to start searching...'),
      );
    } else if (matchQuery.isEmpty) {
      return const Center(
        child: Text('No products found.'),
      );
    } else {
      return CustomScrollView(
        slivers: [
          ProductList(
            products: matchQuery,
          )
        ],
      );
    }
  }
}
