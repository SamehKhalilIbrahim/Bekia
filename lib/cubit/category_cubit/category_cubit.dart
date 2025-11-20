import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/constants.dart';
import '../../services/remote/api_constrains.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  List<String> _categories = [];
  String _selectedCategory = "All";

  CategoryCubit() : super(CategoryInitial());

  String get selectedCategory => _selectedCategory;

  void fetchCategories() async {
    try {
      emit(CategoryLoading());
      final categories = await ProductServices().fetchCategoryList(
        path:
            ApiConstant.baseUrl +
            ApiConstant.productEndpoint +
            ApiConstant.categoryList,
      );
      _categories = ["All", ...categories];

      emit(CategoryLoaded(categories: _categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    emit(
      CategorySelected(
        categories: _categories,
        selectedCategory: _selectedCategory,
      ),
    );
  }
}
