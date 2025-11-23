import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/models/product_model.dart';
import '../../services/constants.dart';

part 'hive_state.dart';

class HiveCubit extends Cubit<HiveState> {
  HiveCubit() : super(HiveInitial());

  final Box<Product> favoritesBox = Hive.box<Product>(
    HiveConstant.favoritesProductBox,
  );

  final Box<Product> cartBox = Hive.box<Product>(HiveConstant.cartProductBox);

  // Favorites methods
  bool isProductFavorite(int productId) {
    return favoritesBox.containsKey(productId);
  }

  void changeFavoriteState(Product product) {
    if (favoritesBox.containsKey(product.id)) {
      favoritesBox.delete(product.id);
    } else {
      favoritesBox.put(product.id, product);
    }
    emit(HiveChangeFavoriteState());
  }

  // Cart methods
  bool isProductInCart(int productId) {
    return cartBox.containsKey(productId);
  }

  void addToCart(Product product) {
    if (cartBox.containsKey(product.id)) {
      // If already in cart, increase quantity
      final existingProduct = cartBox.get(product.id);
      cartBox.put(
        product.id,
        existingProduct!.copyWith(quantity: existingProduct.quantity + 1),
      );
    } else {
      // Add new product with quantity 1
      cartBox.put(product.id, product.copyWith(quantity: 1));
    }
    emit(HiveChangeCartState());
  }

  void removeFromCart(int productId) {
    cartBox.delete(productId);
    emit(HiveChangeCartState());
  }

  void increaseQuantity(Product product) {
    if (cartBox.containsKey(product.id)) {
      final existingProduct = cartBox.get(product.id);
      cartBox.put(
        product.id,
        existingProduct!.copyWith(quantity: existingProduct.quantity + 1),
      );
      emit(HiveChangeCartState());
    }
  }

  void decreaseQuantity(Product product) {
    if (cartBox.containsKey(product.id)) {
      final existingProduct = cartBox.get(product.id);
      if (existingProduct!.quantity > 1) {
        cartBox.put(
          product.id,
          existingProduct.copyWith(quantity: existingProduct.quantity - 1),
        );
      } else {
        // Remove from cart if quantity reaches 0
        cartBox.delete(product.id);
      }
      emit(HiveChangeCartState());
    }
  }

  int getProductQuantity(int productId) {
    if (cartBox.containsKey(productId)) {
      return cartBox.get(productId)!.quantity;
    }
    return 0;
  }
}
