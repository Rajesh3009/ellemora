import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

class CartItem {
  final ProductModel product;
  final int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(ProductModel product) {
    final existingIndex =
        state.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      state = state.map((item) {
        if (item.product.id == product.id) {
          return CartItem(product: item.product, quantity: item.quantity + 1);
        }
        return item;
      }).toList();
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void removeItem(ProductModel product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }

  void updateQuantity(ProductModel product, int quantity) {
    if (quantity <= 0) {
      removeItem(product);
      return;
    }

    state = state.map((item) {
      if (item.product.id == product.id) {
        return CartItem(product: product, quantity: quantity);
      }
      return item;
    }).toList();
  }

  double get total {
    return state.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
