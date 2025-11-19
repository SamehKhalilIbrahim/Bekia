import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

import '../../core/models/product_model.dart';
import '../../services/constants.dart';

part 'hive_state.dart';

class HiveCubit extends Cubit<HiveState> {
  HiveCubit() : super(HiveInitial());

  final Box<Product> favoritesBox = Hive.box<Product>(
    HiveConstant.favoritesProductBox,
  );

  bool isProductFavorite(int productId) {
    return favoritesBox.containsKey(productId);
  }

  void changeFavouriteState(Product product) {
    if (favoritesBox.containsKey(product.id)) {
      favoritesBox.delete(product.id);
    } else {
      favoritesBox.put(product.id, product);
    }
    emit(HiveChangeFavouriteState());
  }
}
