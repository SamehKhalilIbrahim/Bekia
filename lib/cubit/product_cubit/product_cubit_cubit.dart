import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/product_model.dart';
import '../../services/constants.dart';
import '../../services/remote/api_constrains.dart';

part 'product_cubit_state.dart';

class ProductCubit extends Cubit<ProductCubitState> {
  ProductCubit() : super(ProductCubitInitial());

  final int _selectedImageIndex = 0;
  int get selectedImageIndex => _selectedImageIndex;

  void fetchProducts({required String category}) async {
    try {
      emit(ProductLoading());
      final products = await ProductServices().fetchProducts(
        path:
            ApiConstant.baseUrl +
            ApiConstant.productEndpoint +
            (category != "All" ? ApiConstant.category + category : ""),
      );
      if (products.isEmpty) {
        emit(ProductError(message: "No products found."));
      } else {
        emit(ProductsLoaded(products: products));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  late List<Product> products;
  void fetchAllProducts() async {
    try {
      products = await ProductServices().fetchProducts(
        path: ApiConstant.baseUrl + ApiConstant.productEndpoint,
        query: {"limit": 0},
      );
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void changeSelectedImage([int? index]) {
    emit(ChangeSelectedImage(selectedImage: index ?? 0));
  }
}
